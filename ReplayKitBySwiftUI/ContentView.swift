//
//  ContentView.swift
//  ReplayKitBySwiftUI
//
//  Created by Jerry LEE on 2020/2/7.
//  Copyright © 2020 JerryStudio. All rights reserved.
//

import SwiftUI
import ReplayKit

struct ContentView: View {
    private let recorder = RPScreenRecorder.shared()
    @State private var isBool = false
    @State var rp: RPPreviewView!
    @State private var isRecording = false
    @State private var isShowPreviewVideo = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Hello, World!")
                    .font(.title)
                    .foregroundColor(isBool ? .red : .green)
                    .onTapGesture {
                        self.isBool.toggle()
                    }
                Button(action: {
                    if !self.isRecording {
                        self.startRecord()
                    } else {
                        self.stopRecord()
                    }
                }) {
                    Image(systemName: isRecording ? "stop.circle" : "video.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
            if isShowPreviewVideo {
                rp
                    .transition(.move(edge: .bottom))
                    .edgesIgnoringSafeArea(.all)
                
            }
        }
    }
    
    private func startRecord() {
        guard recorder.isAvailable else {
            print("Recording is not available at this time.")
            return
        }
        if !recorder.isRecording {
            recorder.startRecording { (error) in
                guard error == nil else {
                    print("There was an error starting the recording.")
                    return
                }
                print("Started Recording Successfully")
                self.isRecording = true
            }
        }
    }
    
    private func stopRecord() {
        recorder.stopRecording { (preview, error) in
            print("Stopped recording")
            self.isRecording = false

            guard let preview = preview else {
                print("Preview controller is not available.")
                return
            }
            self.rp = RPPreviewView(rpPreviewViewController: preview, isShow: self.$isShowPreviewVideo)
            withAnimation {
                self.isShowPreviewVideo = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RPPreviewView: UIViewControllerRepresentable {
    let rpPreviewViewController: RPPreviewViewController
    @Binding var isShow: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> RPPreviewViewController {
        rpPreviewViewController.previewControllerDelegate = context.coordinator
        rpPreviewViewController.modalPresentationStyle = .fullScreen
        
        return rpPreviewViewController
    }
    
    func updateUIViewController(_ uiViewController: RPPreviewViewController, context: Context) { }
    
    class Coordinator: NSObject, RPPreviewViewControllerDelegate {
        var parent: RPPreviewView
           
        init(_ parent: RPPreviewView) {
            self.parent = parent
        }
           
        func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
            withAnimation {
                parent.isShow = false
            }
        }
    }
}
