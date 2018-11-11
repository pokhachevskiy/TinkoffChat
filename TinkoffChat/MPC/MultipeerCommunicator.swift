//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator,
MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {

    weak var delegate: CommunicatorDelegate?

    var online: Bool = false

    private lazy var session: MCSession = {
        let session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        return session
    }()

    var peer: MCPeerID

    let serviceType = "tinkoff-chat"

    var browser: MCNearbyServiceBrowser

    var advertiser: MCNearbyServiceAdvertiser

    private func generateMessageId() -> String {
        return
            "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
                .data(using: .utf8)!
                .base64EncodedString()
    }

    override init() {
        peer = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)

        online = true

        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        advertiser = MCNearbyServiceAdvertiser(peer: peer,
                                               discoveryInfo: ["userName": UIDevice.current.name],
                                               serviceType: serviceType)

        super.init()
        browser.delegate = self
        advertiser.delegate = self

        browser.startBrowsingForPeers()
        advertiser.startAdvertisingPeer()
    }

    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        online = false
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            print("\(peerID.displayName) connected")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let jsonMessage = try JSONSerialization.jsonObject(with: data,
                                                               options: .mutableContainers) as? [String: String]
            if let text = jsonMessage?["text"] {
                delegate?.didReceiveMessage(text: text, fromUser: peerID.displayName, toUser: peer.displayName)
            }
        } catch {
            print("Can't parse response.")
        }
    }

    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession,
                 didReceiveCertificate certificate: [Any]?,
                 fromPeer peerID: MCPeerID,
                 certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {

    }

    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, at localURL: URL?,
                 withError error: Error?) {

    }

    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String: String]?) {
        if let info = info {
            delegate?.didFoundUser(userID: peerID.displayName, userName: info["userName"])
        }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 60)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedtoStartAdvertising(error: error)
    }

    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        if let indexTo = session.connectedPeers.index(where: {item -> Bool in item.displayName == userID}) {
            do {
                var message = [String: String]()
                message["eventType"] = "TextMessage"
                message["text"] = string
                message["messageId"] = generateMessageId()

                let jsonMessage = try? JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
                try session.send(jsonMessage!, toPeers: [session.connectedPeers[indexTo]], with: .reliable)
                completionHandler?(true, nil)
            } catch let error {
                completionHandler?(false, error)
            }
        }
    }

}
