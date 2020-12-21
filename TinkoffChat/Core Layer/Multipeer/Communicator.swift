//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Pokhachevskiy. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicator: class {
    func sendMessage(text: String, to userId: String, completionHandler: (_ success: Bool, _ error: Error?) -> Void)
    var delegate: ICommunicatorDelegate? { get set }
    var online: Bool { get set }
}

class MultipeerCommunicator: NSObject, ICommunicator {
    weak var delegate: ICommunicatorDelegate?
    private let serviceType = "tinkoff-chat"

    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser

    var online: Bool

    override init() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId,
                                                      discoveryInfo: ["userName": UIDevice.current.name],
                                                      serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        online = true

        super.init()

        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()

        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }

    private lazy var session: MCSession = {
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        return session
    }()

    func sendMessage(text: String, to userId: String, completionHandler: (_ success: Bool, _ error: Error?) -> Void) {
        guard let index = session.connectedPeers.index(where: { (item) -> Bool in
            item.displayName == userId
        }) else { return }

        let message = ["eventType": "TextMessage",
                       "text": text,
                       "messageId": Message.generateMessageId()]

        do {
            guard let json = try? JSONSerialization.data(withJSONObject: message, options: .prettyPrinted) else {
                completionHandler(false, nil)
                return
            }
            try session.send(json, toPeers: [session.connectedPeers[index]], with: .reliable)
            delegate?.didSendMessage(text: text, to: userId)
            completionHandler(true, nil)
        } catch {
            completionHandler(false, error)
        }
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }

    func advertiser(_: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer _: MCPeerID,
                    withContext _: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        invitationHandler(true, session)
    }
}

// MARK: - MCSessionDelegate

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_: MCSession, peer _: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            print("State changed: connected")
        }
    }

    func session(_: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let myJson = try JSONSerialization.jsonObject(with: data,
                                                          options: .mutableContainers) as? [String: String]

            if let text = myJson?["text"] {
                delegate?.didReceiveMessage(text: text, from: peerID.displayName)
            }
        } catch {
            print("Can't parse responce.")
        }
    }

    func session(_: MCSession,
                 didReceiveCertificate _: [Any]?,
                 fromPeer _: MCPeerID,
                 certificateHandler: @escaping (Bool) -> Void)
    {
        certificateHandler(true)
    }

    func session(_: MCSession,
                 didStartReceivingResourceWithName _: String,
                 fromPeer _: MCPeerID,
                 with _: Progress) {}

    func session(_: MCSession,
                 didReceive _: InputStream,
                 withName _: String,
                 fromPeer _: MCPeerID) {}

    func session(_: MCSession,
                 didFinishReceivingResourceWithName _: String,
                 fromPeer _: MCPeerID,
                 at _: URL?,
                 withError _: Error?) {}
}

// MARK: - MCNearbyServiceBrowserDelegate

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }

    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String: String]?)
    {
        guard let userName = info?["userName"] else {
            return
        }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 60)
        delegate?.didFindUser(id: peerID.displayName, name: userName)
    }

    func browser(_: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLoseUser(id: peerID.displayName)
    }
}
