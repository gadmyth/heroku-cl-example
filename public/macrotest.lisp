(keyview
 (main_title "a")
 (alt_title "!")
 (shift_title "{")
)

(keyview :main_title "a" :alt_title "!" :shift_title "{")

(keydown kv
	 (showdown)
	 (show-popup))

(keyup kv
	 (showup)
	 (hide-popup)
	 (progress-event))
