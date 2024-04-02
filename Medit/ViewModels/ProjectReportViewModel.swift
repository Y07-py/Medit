//
//  ProjectReportViewModel.swift
//  Medit
//
//  Created by 木本瑛介 on 2024/02/17.
//

import Foundation
import SwiftUI
import Combine

class projectReportViewModel: ObservableObject {
    @Published var selectedUrl: URL?
    @Published var status: String = "Trouble in addng the file right now"
    @Published var progressing: Bool = false
    @Published var project: String?
    @Published var showStatus: Bool = false
    
    private var ldh: LocalDocumentHandler = LocalDocumentHandler()
    
    init(project: String?) {
        self.project = project
        DispatchQueue.global(qos: .userInitiated).async {[self] in
            ldh.startupActivities(project: project ?? "project")
        }
    }
    
    func addURLs(pickedURL: URL) {
        var res: URL?
        
            DispatchQueue.main.async {
                self.progressing = true
            }
            res = ldh.copyDocumentsToLocalDirectory(pickedURL: pickedURL, project: self.project ?? "project")
            if res == nil {
                DispatchQueue.main.async {
                    if !self.showStatus {
                        self.status = "Unable to add the file reight now"
                        self.showStatus = true
                    }
                }
            } else {
                self.selectedUrl = res
                self.showStatus = true
                
            }
            DispatchQueue.main.async {
                self.progressing = false
            }
    }
    
    func generateUrl() -> URL? {
        let url: URL? = ldh.giveURL(project: self.project ?? "project", file: "file")
        
        if url?.isFileURL ?? false {
            return url
        }
        self.status = "Document does not belong to this device"
        self.showStatus = true
        return nil
    }
}
