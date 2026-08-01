+++
title = "The \"Have You Tried Turning It Off and On Again?\" Remote Setup"
description = "A guide to setting up remote gaming and work using Parsec with a client laptop connected to a powerful desktop PC."
date = 2025-12-23
draft = false
slug = "parsec-setup"
aliases = ["/parsec-setup/"]

[taxonomies]
categories = ["tech"]
tags = ["parsec", "remote", "gaming", "setup", "productivity"]

[extra]
comments = true
lang = "en"
image = "pc_pic.jpg"  
+++

# The "Have You Tried Turning It Off and On Again?" Remote Setup

With the holiday season coming up and me planning on going back home. I didn't want to leave my main PC behind when I traveled. I’ve spent the last few months getting comfortable with it as my daily driver (Ryzen 7 9700X, RTX 5070 Ti), and frankly, trying to do game dev on a laptop usually involves thermal throttling and jet-engine fan noise.

So, I rigged my desktop to be accessible from anywhere.

The software part is standard: I use **Parsec**. The catch is that Parsec *still* doesn't support hosting on Ubuntu. Since I dual boot, I had to set the GRUB bootloader to prioritize Windows. If the machine restarts, it needs to land in Windows, or I’m locked out.

But the hardware side is where the real magic happens.

I plugged the PC into a smart plug that measures power consumption. Then, I went into the BIOS and enabled **"Restore on AC Power Loss"**.

This gives me a physical "kill switch" accessible from my phone.

If the PC freezes or hangs for any reason:

1.  I open the smart plug app.
2.  I kill the power.
3.  I turn it back on.

The PC detects the "power outage," automatically boots itself up, loads Windows, and Parsec is back online.

It’s the ultimate remote troubleshooting tool. I can check the power draw to see if it's actually working or just idling, and I have the peace of mind that I can always hard-reset the system, even from a different continent.

Works like a charm.... if I ignore that fact that both my old gaming laptop (with it's 1060M) and my surface pro 7 (with its integrated graphics) don't support hardware 4:4:4 color decoding and both are strugging with battery life. Macbook air looking at me right now like:

<div style="width:100%;height:0;padding-bottom:48%;position:relative;"><iframe src="https://giphy.com/embed/V6R9thgW7fimI" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p><a href="https://giphy.com/gifs/creepy-beard-zach-galifianakis-V6R9thgW7fimI">via GIPHY</a></p> 