/client/proc/text2speech(msg)
	if(!config.ttsenabled)
		usr << "<span class='notice'>TTS Not enabled on this server!</span>"
		return
	if(!config.ttsurl)
		usr << "<span class='notice'>TTS URL not set on this server!</span>"
		return
	if(!msg)
		msg = input(usr, "Text To Speech", "Text")  as text|null

	var/url = "[config.ttsurl]?text=[url_encode(msg)]"
	world << world.Export(url)