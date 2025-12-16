lib: {
  gen = { hmConfig }: 
    let
      userName = "marrero";
      userUid = 1000;
    in {
      autoStart = false;
      privateNetwork = true;
	
      bindMounts = {
	waylandDisplay = rec {
          hostPath = "/run/user/${toString userUid}";
          mountPoint = hostPath;
	};
      };

      config = {
	hardware.graphics.enable = true;

	home-manager = {
	  users."${userName}" = {
	    home.sessionVariables = {
	      WAYLAND_DISPLAY                     = "wayland-1";
	      QT_QPA_PLATFORM                     = "wayland";
	      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
	      SDL_VIDEODRIVER                     = "wayland";
	      CLUTTER_BACKEND                     = "wayland";
	      MOZ_ENABLE_WAYLAND                  = "1";
	      _JAVA_AWT_WM_NONREPARENTING         = "1";
	      _JAVA_OPTIONS                       = "-Dawt.useSystemAAFontSettings=lcd";
	      XDG_RUNTIME_DIR                     = "/run/user/${toString userUid}";
            };
	  } // hmConfig;
	};
      };
    };
}
