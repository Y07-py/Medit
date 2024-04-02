//
//  LocalDocumentHandler.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/17.
//

import Foundation
import UIKit

struct LocalDocumentHandler {
    var subfolder: String
    var rootUrl: URL?
    
    init() {
        self.subfolder = "Projects"
        do {
            if let fileManagerUrl: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.maheshsai.walker") {
                self.rootUrl = fileManagerUrl
            } else {
                self.rootUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            }
        } catch {
            print(error)
        }
    }
    
    // create directoryes for project to store documents inside it
    func startupActivities(project: String) {
        createSubFolderDirectory()
        createProjectInsideDocumentsDirectory(project: project)
    }
    
    func createSubFolderDirectory() {
        guard let url = self.rootUrl else { return }
        let newUrl = url.appending(path: self.subfolder, directoryHint: .inferFromPath)
        
        if (!FileManager.default.fileExists(atPath: newUrl.path(), isDirectory: nil)) {
            do {
                try FileManager.default.createDirectory(at: newUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error in creating doc")
            }
        }
    }
    
    //Create ./Documents/Projects/<Project name>
    func createProjectInsideDocumentsDirectory(project: String) {
        do {
            guard let url = rootUrl else { return }
            let documentsURL: URL = url.appending(path: subfolder, directoryHint: .inferFromPath)
                                          .appending(component: project, directoryHint: .inferFromPath)
            if (!FileManager.default.fileExists(atPath: documentsURL.path(percentEncoded: true), isDirectory: nil)) {
                try FileManager.default.createDirectory(at: documentsURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print(error)
        }
    }
    
    // copy local path and return it
    func copyDocumentsToLocalDirectory(pickedURL: URL, project: String) -> URL? {
        guard let url = self.rootUrl else { return nil }
        do {
            var destinationDocumentsURL: URL = url
            destinationDocumentsURL = destinationDocumentsURL.appending(path: subfolder, directoryHint: .inferFromPath)
                                                             .appending(path: project, directoryHint: .inferFromPath)
                                                             .appending(path: pickedURL.lastPathComponent, directoryHint: .inferFromPath)
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: destinationDocumentsURL.path(percentEncoded: true), isDirectory: &isDir) {
                try FileManager.default.removeItem(at: destinationDocumentsURL)
            }
            guard pickedURL.startAccessingSecurityScopedResource() else { print("some problem"); return nil }
            defer {
                pickedURL.stopAccessingSecurityScopedResource()
            }
            try FileManager.default.copyItem(at: pickedURL, to: destinationDocumentsURL)
            return destinationDocumentsURL
        } catch {
            print(error)
        }
        return nil
    }
    
    func giveURL(project: String, file: String) -> URL? {
        guard var documentURL: URL = self.rootUrl?.appending(path: subfolder)
            .appending(path: project) else { return nil }
        documentURL = documentURL.appending(path: file)
        return documentURL
    }
    
    // remove project directory
    func removeProjectDirectory(project: String) {
        guard let url = self.rootUrl else { return }
        let localDocumentsURL = url.appending(path: subfolder, directoryHint: .inferFromPath)
                                   .appending(path: project, directoryHint: .inferFromPath)
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: localDocumentsURL.path(percentEncoded: true), isDirectory: &isDir) {
            do {
                try FileManager.default.removeItem(at: localDocumentsURL)
            } catch {
                print(error)
            }
        }
    }
    
    // remove Document at URL
    func removeUsingUrl(localURL: URL) {
        do {
            try FileManager.default.removeItem(at: localURL)
        } catch {
            print(error)
        }
    }
}
