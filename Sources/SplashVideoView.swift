import SwiftUI
import AVKit

struct SplashVideoView: View {
    var onFinished: () -> Void
    
    @State private var player: AVPlayer? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            if let player = player {
                VideoPlayerView(player: player)
                    .ignoresSafeArea()
            }
            
            // Skip Button
            Button(action: {
                player?.pause()
                onFinished()
            }) {
                HStack(spacing: 4) {
                    Text("跳過")
                        .font(.caption)
                        .bold()
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.6))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .padding(.top, 50)
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
        let videoPath = "/Users/zhao/工作專區/清心ios app/share/開頭動畫.mp4"
        let videoURL = URL(fileURLWithPath: videoPath)
        let avPlayer = AVPlayer(url: videoURL)
        self.player = avPlayer
        
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

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        context.coordinator.playerLayer = playerLayer
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.playerLayer?.frame = uiView.bounds
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var playerLayer: AVPlayerLayer?
    }
}
