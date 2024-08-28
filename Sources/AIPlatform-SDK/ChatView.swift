//
//  ChatView.swift
//
//
//  Created by Mac on 7/17/24.
//

import Foundation
import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    @StateObject private var imageContainerModel = ImageContainerModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack {
                HStack {
                    Button {
                        imageContainerModel.showingPopover.toggle()
                    } label: {
                        Text("X")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(10)
                            .padding(.horizontal, 10)
                    }
                        .clipShape(Circle())
                        .shadow(radius: 2)
                    Text("VPBANK - Hỗ trợ mọi lúc mộ nơi")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(10)
                        .foregroundColor(.white)
                }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            }
                .background(Color(hex: "#181d30"))
                .padding(.bottom, 15)
            VStack {
                // scroll mess
                ScrollView {
                    ScrollViewReader { scrollView in
                        VStack {
                            ForEach(viewModel.messages) { message in
                                VStack {
                                    // mess created_at
                                    HStack {
                                        Text(message.created_at)
                                            .foregroundColor(Color(hex: "#848b95"))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .font(.system(size: 15))
                                    }
                                        .frame(maxWidth: .infinity)
                                    // message content
                                    HStack(alignment: .top) {
                                        if message.isUserMessage {
                                            Spacer()
                                            Text(message.text)
                                                .padding()
                                                .background(Color(hex: "#00ad51"))
                                                .cornerRadius(10)
                                                .foregroundColor(.white)
                                        } else {
                                            loadImageFromURL(
                                                urlImage: "https://trolyao.vpbank.com.vn/images/logo-vp.png",
                                                defaultImage: "logo-vp"
                                            )
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.white)
                                                .padding(.trailing, 7)
                                            VStack(alignment: .leading) {
                                                Text(message.text)
                                                    .padding()
                                                    .background(Color(hex: "#181d30"))
                                                    .cornerRadius(10)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 0)
                                                if message.type.rawValue == 1 {
                                                    // rowLike
                                                    rowLike(message: message)
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                        .padding(.bottom, 5)
                                }
                            }
                        }
                        .onChange(of: viewModel.messages) { _ in
                            if let lastMessage = viewModel.messages.last {
                                withAnimation {
                                    scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
//              input mess
                HStack {
                    CustomTextField(
                        text: $viewModel.currentMessage,
                        placeholder: "Enter your text here...",
                        placeholderColor: UIColor.gray,
                        padding: 10,
                        borderColor: UIColor.white,
                        cornerRadius: 20,
//                        height: 60,
                        onSubmit: {
                            sendMessage()
                        }
                    )
                        .frame(maxHeight: 60)
                    Button(action: {
                        sendMessage()
                    }) {
                        loadImageFromURL(
                            urlImage: "",
                            defaultImage: "btn-send"
                        )
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                    }
                        .background(Color.blue)
                        .cornerRadius(50)
                }
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
            }
                .padding(.horizontal, 10)
        }
        .onAppear {
            viewModel.openBoxchat()
            viewModel.loadMessages()
        }
        .onDisappear {
            viewModel.saveMessages()
        }
    }
    
    func sendMessage() {
        viewModel.sendMessage()
    }
    
    private func rowLike(message: ChatMessage) -> some View {
        HStack {
            Spacer()
            if message.isLike == true || message.isLike == nil {
                Button(action: {
                    viewModel.toggleLike(for: message, isLike: true)
                }) {
                    loadImageFromURL(
                        urlImage: "",
                        defaultImage: "like"
                    )
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(.top, message.isLike == true ? 4 : 0)
                }
                    .padding(.leading, 10)
            }
            if message.isLike == false || message.isLike == nil {
                Button(action: {
                    viewModel.toggleLike(for: message, isLike: false)
                }) {
                    loadImageFromURL(
                        urlImage: "",
                        defaultImage: "dislike"
                    )
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
                    .padding(.leading, 10)
            }
        }
            .padding(.top, 2)
    }
}

