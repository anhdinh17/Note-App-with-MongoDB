//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by Anh Dinh on 3/2/21.
//
import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [Song] = []

    // why is this?
    @IBOutlet var holder: UIView!
    
    // create a var for AVAudioPlayer
    var player: AVAudioPlayer?
    
    // User Interface elements
    // using anonymousc closure to create view
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()
    
    // we make play/pause button global because we gonna change its image outside of configure()
    let playPauseButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // éo hiểu tại sao có dòng này
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
    func configure(){
        // Set songs player
        let song = songs[position]
        
        // url for the position of the song
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do{
            // setup AVAudio
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            // make sure we got the url path for the songs
            guard let urlString = urlString else{
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            // unwrap player
            guard let player = player else {
                return
            }
            player.volume = 0.5 // set starting volume
            player.play() // play the song
            
        }catch{
            print("error")
        }
        
        //MARK: - Add frame and subviews
        // album cover
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width - 20,
                                      height: holder.frame.size.width - 20)
        albumImageView.image = UIImage(named: song.imageName)
        holder.addSubview(albumImageView)
        
        // Labels frame and add subviews for: song name, artist name, album name
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 70,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        
        artistNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 140,
                                      width: holder.frame.size.width - 20,
                                      height: 70)
        
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(artistNameLabel)
        holder.addSubview(albumNameLabel)
        
        // Player Control, create buttons
        let nextButton = UIButton()
        let backButton = UIButton()
        
            //frame for buttons
        let yPosition = artistNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 70
        
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size)/2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        nextButton.frame = CGRect(x: holder.frame.size.width - size - 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        
        
            // Add actions for buttons
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
            // images for buttons
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        backButton.tintColor = .black
        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        
        
        // Slider, cách làm tắt để tạo frame luôn
        let slider = UISlider(frame: CGRect(x: 20,
                                            y: holder.frame.size.height - 60,
                                            width: holder.frame.size.width - 40,
                                            height: 50))
        slider.value = 0.5
        // what happens when sliding the slider
        // this is like we create a function for button/slider
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder.addSubview(slider)
        
    }
    
//MARK: - Buttons func
    
    @objc func didTapBackButton(){
        // check if we are not at the first song, important check
        if position > 0{
            position = position - 1
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
        
    }
    
    @objc func didTapPlayPauseButton(){
        if player?.isPlaying == true{
            // if player is playing the song, pause it.
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }else{
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
            
    }
    
    @objc func didTapNextButton(){
        if position < (songs.count - 1){
            position = position + 1
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didSlideSlider(_ slider: UISlider){
        let value = slider.value
        player?.volume = value
        // adjust volume
    }
    
    // if users swipe down the screen, stop the music
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }

}
