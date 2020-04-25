local composer = require( "composer" );

local soundTable = {
	mainBGM = audio.loadSound( "blobbySamba.mp3" ),
}

local function playBGM()
	audio.play( soundTable["mainBGM"],{channel=32, onComplete=playBGM});
	--Background music is Blobby Samba by the amazing and generous Kevin Macleod	
end

playBGM()
audio.setVolume(0.15, {channel=32})



composer.gotoScene("mainMenu", {effect="fade",time=500});