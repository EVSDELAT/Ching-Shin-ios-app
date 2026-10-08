import SwiftUI
import AVKit

struct SplashVideoView: View {
    var onFinished: () -> Void
    
    @State private var player: AVPlayer? = nil
    @State private var isVideoReady = false
    @State private var pulseLogo = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            if let player = player, isVideoReady {
                VideoPlayerContainerView(player: player)
                    .ignoresSafeArea()
            } else {
                // Fallback brand animated splash if video is loading or unsupported
                VStack(spacing: 24) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color(hex: "008B47").opacity(0.2))
                            .frame(width: 140, height: 140)
                            .scaleEffect(pulseLogo ? 1.15 : 0.95)
                        
                        Circle()
                            .fill(Color(hex: "008B47"))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.red)
                    }
                    
                    VStack(spacing: 8) {
                        Text("清心福全")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Ching Shin Fu Chuan · 1987")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        pulseLogo = true
                    }
                }
            }
            
            // Modern Minimalist 'X' Close Button (Mandatory User Requirement #7)
            Button(action: {
                SoundManager.shared.playTapSound()
                player?.pause()
                onFinished()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)
                .padding(.top, 56)
                .padding(.trailing, 20)
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
    
    private func setupPlayer() {
        var videoURL: URL? = nil
        
        if let bundleURL = Bundle.main.url(forResource: "開頭動畫", withExtension: "mp4") {
            videoURL = bundleURL
        } else if let bundleURL = Bundle.main.url(forResource: "intro", withExtension: "mp4") {
            videoURL = bundleURL
        } else {
            let localPath = "/Users/zhao/工作專區/清心ios app/share/開頭動畫.mp4"
            if FileManager.default.fileExists(atPath: localPath) {
                videoURL = URL(fileURLWithPath: localPath)
            }
        }
        
        guard let url = videoURL else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onFinished()
            }
            return
        }
        
        let avPlayer = AVPlayer(url: url)
        self.player = avPlayer
        self.isVideoReady = true
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: avPlayer.currentItem,
            queue: .main
        ) { _ in
            onFinished()
        }
        
        avPlayer.play()
    }
}

struct VideoPlayerContainerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView(player: player)
        return view
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        uiView.updatePlayer(player: player)
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePlayer(player: AVPlayer) {
        if playerLayer.player != player {
            playerLayer.player = player
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
