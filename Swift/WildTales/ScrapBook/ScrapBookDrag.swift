//
//  ScrapBookDrag.swift
//  WildTales
//
//  Created by Yujie Wei on 10/5/2025.
//  Heavily inspired by the following content
//  Inspired by https://www.youtube.com/watch?v=2ZK5wfbvvS4
//  Inspired by https://www.youtube.com/watch?v=lMteVjlOIbM
//  Inspired by https://www.youtube.com/watch?v=ZkOvD3okAJo
//  Function createDragGesture and function undoLastAction are derived from google gemini with the prompt "If I want to drag and drop the sticker image to the scene image. How can I edit code to do it?" The other parts of code like variables dragStartPosition,currentDragSticker, dragOffset, etc are also modified according to the code provided by genAI

import SwiftUI

struct DropSticker: Identifiable {
    let id = UUID()
    var imageName: String
    var position: CGPoint
}

struct SelectSticker: Identifiable {
    let id = UUID()
    let imageName: String
}

struct ScrapBookDrag: View {
    let image: Image

    @Environment(\.presentationMode) var goBack

    @State private var finishedSticker: [DropSticker] = []
    @State private var currentDragSticker: SelectSticker? = nil
    @State private var dragOffset: CGSize = .zero
    @State private var dragStartPosition: CGPoint? = nil
    @State private var photoAreaLocation: CGRect = .zero
    @State private var stickerIndex = 2

    let areaCoordinateSpace = "photoDropArea"
    let zoomedStickerSize: CGFloat = 70
    let placedStickerSize: CGFloat = 60

    let StickersInBar: [SelectSticker] = [
        SelectSticker(imageName: "badgeQuin"),
        SelectSticker(imageName: "badgeBird"),
        SelectSticker(imageName: "badgeMoon"),
        SelectSticker(imageName: "badgeRat"),
        SelectSticker(imageName: "badgeCrane")
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Header.padding(.bottom, UIScreen.main.bounds.height * 0.08)
                PrimaryPhoto.padding(.horizontal, 20)
                Spacer()
                StickerSelectionView.padding(.vertical, 10)
                BottomButton
            }

            if let sticker = currentDragSticker, let startPos = dragStartPosition {
                Image(sticker.imageName)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.7)
                    .frame(width: zoomedStickerSize)
                    .position(x: startPos.x + dragOffset.width,
                              y: startPos.y + dragOffset.height)
            }

            TopBackButton
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 40)
                .ignoresSafeArea()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.white)
        .navigationBarHidden(true)
    }

    var Header: some View {
        HStack {
            Spacer().frame(width: UIScreen.main.bounds.width * 0.2)
            VStack {
                Text("At Tropical Dome").bold().font(Font.custom("Inter", size: 30)).foregroundColor(.green1)
                Text("Drag sticker to decorate photo").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            Button {
                undoLastAction()
                AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .font(.title)
            }
            .disabled(finishedSticker.isEmpty)
            .padding(.trailing, 20)
        }
        .foregroundColor(.green1)
        .frame(height: 50)
        .padding(.top, safeAreaTop())
    }

    var PrimaryPhoto: some View {
        GeometryReader { geometry in
            photoArea
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .onAppear {
                    photoAreaLocation = geometry.frame(in: .global)
                }
                .onChange(of: geometry.frame(in: .global)) {
                    newValue in photoAreaLocation = newValue
                }
                .coordinateSpace(name: areaCoordinateSpace)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8,
               height: UIScreen.main.bounds.height * 0.4)
    }

    var photoArea: some View {
        let screenWidth = UIScreen.main.bounds.width
        let photoAreaWidth = min(screenWidth - 60, 330)
        let photoAreaHeight = photoAreaWidth * (4.0/3.0)

        return ZStack(alignment: .topTrailing) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: photoAreaWidth, height: photoAreaHeight)
                .clipped()

            ForEach(finishedSticker) { sticker in
                Image(sticker.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: placedStickerSize)
                    .position(sticker.position)
            }

        }.frame(width: photoAreaWidth, height: photoAreaHeight)
    }

    var StickerSelectionView: some View {
        ScrollViewReader { proxy in
            HStack(spacing: 15) {
                Button {
                    withAnimation {
                        stickerIndex = max(0, stickerIndex - 2)
                        let targetID = StickersInBar[stickerIndex].id
                        proxy.scrollTo(targetID, anchor: .center)
                    }
                    AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                } label: {
                    Image("back_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.leading, -7)
                }.disabled(stickerIndex == 0)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(StickersInBar) { sticker in
                            Image(sticker.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .cornerRadius(5)
                                .id(sticker.id)
                                .gesture(createDragGesture(for: sticker))
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .frame(height: 70)

                Button {
                    withAnimation {
                        stickerIndex = min(StickersInBar.count - 1, stickerIndex + 2)
                        let targetID = StickersInBar[stickerIndex].id
                        proxy.scrollTo(targetID, anchor: .center)
                    }
                    AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
                } label: {
                    Image("forward_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(.trailing, -7)
                }.disabled(stickerIndex >= StickersInBar.count - 1)
            }
            .padding(.horizontal)
            .foregroundColor(.green1)
        }
    }

    var BottomButton: some View {
        HStack(spacing: 30) {
            Spacer()
            Button {
                print("Add some sticker")
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill").font(.system(size: 24))
                    Text("Add Some\nStickers").font(.caption).multilineTextAlignment(.center).lineLimit(2)
                }.foregroundColor(.green1).frame(minWidth: 100)
            }
            Spacer()
            Button {
                print("Write experience")
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "pencil.line").font(.system(size: 24))
                    Text("Write Your\nExperience").font(.caption).multilineTextAlignment(.center).lineLimit(2)
                }.foregroundColor(.green1).frame(minWidth: 100)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .padding(.bottom, safeAreaBottom())
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.black), lineWidth: 1))
    }

    var TopBackButton: some View {
        Button {
            AudioManager.playSound(soundName: "boing.wav", soundVol: 0.5)
            goBack.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
        }
        .font(.system(size: 40))
        .foregroundColor(Color("HunterGreen"))
        .shadow(radius: 5)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    func createDragGesture(for sticker: SelectSticker) -> some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                if dragStartPosition == nil { dragStartPosition = value.startLocation }
                if currentDragSticker == nil { currentDragSticker = sticker }
                dragOffset = CGSize(width: value.location.x - value.startLocation.x,
                                    height: value.location.y - value.startLocation.y)
            }
            .onEnded { value in
                if let currentSticker = currentDragSticker,
                   photoAreaLocation.contains(value.location) {
                    let localX = value.location.x - photoAreaLocation.origin.x
                    let localY = value.location.y - photoAreaLocation.origin.y
                    let localPosition = CGPoint(x: localX, y: localY)
                    let newSticker = DropSticker(imageName: currentSticker.imageName, position: localPosition)
                    finishedSticker.append(newSticker)
                }
                currentDragSticker = nil
                dragOffset = .zero
                dragStartPosition = nil
            }
    }

    func undoLastAction() {
        if !finishedSticker.isEmpty {
            finishedSticker.removeLast()
        } else {
            print("Undo: Error")
        }
    }

    func safeAreaTop() -> CGFloat { return 40 }
    func safeAreaBottom() -> CGFloat { return 30 }
}

struct ScrapBookDrag_Previews: PreviewProvider {
    static var previews: some View {
        ScrapBookDrag(image: Image("displayImage3"))
    }
}
