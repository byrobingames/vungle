## Stencyl Vungle ads iOS/Android Extension (OpenFL)

For Stencyl 3.4 and above

Stencyl extension for “Vungle” (http://www.vungle.com) for iOS and Android. This extension allows you to easily integrate Vungle on your Stencyl game / application. (http://www.stencyl.com)

### Important!!

This Extension Required the Toolset Extension Manager [https://byrobingames.github.io](https://byrobingames.github.io)

![vungletoolset](https://byrobingames.github.io/img/vungle/vungletoolset.png)

## Main Features

  * Video Support.
  * Rewarded Video Support.
  
### GDPR Compliance

As of May 25th, the General Data Protection Regulation (GDPR) will be enforced in the European Union. To comply with GDPR, developers have two options.

**Option 1 (recommended):** Publisher controls the GDPR consent process at the user level, then communicates the user’s choice to Vungle. To do this, developers can collect the user’s consent using their own mechanism, and then use Vungle APIs to update or query the user’s consent status. Refer to the GDPR Recommended Implementation Instruction section for details.
**Option 2:** Allow Vungle to handle the requirements. Vungle will display a consent dialog before playing an ad for a European user, and will remember the user’s consent or rejection for subsequent ads.
  
## How to Install

To install this Engine Extension, go to the toolset (byRobin Extension Mananger) in the Extension menu of your game inside Stencyl.<br/>
![toolsetextensionlocation](https://byrobingames.github.io/img/toolset/toolsetextensionlocation.png)<br/>
Select the Extension from the menu and click on "Download"

If you not have byRobin Extension Mananger installed, install this first.<br/>
Go to: [https://byrobingames.github.io](https://byrobingames.github.io)

## Documentation and Block Examples

If you don’t have an account, create one on [https://publisher.vungle.com](https://publisher.vungle.com) and get your “AppID” and "Placements Reference Id"

Fill in your “AppID” in the Toolset Manager<br/>
![vungleappid](https://byrobingames.github.io/img/vungle/vungleappid.png)<br/>

<span style="color:red;">!!ON ANDROID YOU NEED TO ENABLE ADMOB ADS INSIDE STENCYL!!</span>

### Blocks

**Initialize Vungle**<br/>
![vungleinitialize](https://byrobingames.github.io/img/vungle/vungleinitialize.png)<br/>
Use this block to initialize Vungle. Use this block once per user
session (from the moment the user starts to play until the user quits the game). For example in a loading scene.

<hr/>

**Load Vungle ad with placement Id**<br/>
![vungleloadads](https://byrobingames.github.io/img/vungle/vungleloadads.png)<br/>
Use this block to load ads where auto-cached in dashboard is disabled .

**Show Vungle interstitial of Rewarded ad with placement Id**<br/>
![vungleshowads](https://byrobingames.github.io/img/vungle/vungleshowads.png)<br/>
Use this block to show a Interstitial or Rewarded. When showing rewarded ad, the user gets a popup when he close the ad early.

<hr/>

**Callback for Ads**<br/>
![vunglecallbacks](https://byrobingames.github.io/img/vungle/vunglecallbacks.png)<br/>
Use this block to get the callbacks of an Ad with placementId.

<hr/>

**Set Consent** (Europe only)<br/>
![vunglesetconsent](https://byrobingames.github.io/img/vungle/vunglesetconsent.png)<br/>
Set the Consent of user programmatically.

<hr/>

**Get Consent** (Europe only)<br/>
![vunglegetconsent](https://byrobingames.github.io/img/vungle/vunglegetconsent.png)<br/>
Get the Consent of user programmatically returns true when OPTED_IN is set and returns false when OPTED_OUT is set. If Consent is not set it will return false.

## Version History

- 2016-03-28 (0.0.1) First release
- 2016-09-25 (0.0.2) Update iOS SDK 4.05 and Android SDK 4.02
- 2016-11-18 (0.0.3)  Updated to use with Heyzap Extension 2.7
- 2017-03-19 (0.0.4)  Updated to use with Heyzap Extension 2.9, Update iOS SDK to 4.0.9, Added Android Gradle support.
- 2017-05-16(0.0.5)  Tested for Stencyl 3.5, Required byRobin Toolset Extension Manager
- 2019-01-13(0.0.6)  Update iOS SDK to 6.3.2 and Android SDK to 6.3.24; Added set/get users consent; Added load block; Android JNI import fix; Added placement support; byRobinextensionmanager 0.2.3 required

## Submitting a Pull Request

This software is opensource.<br/>
If you want to contribute you can make a pull request

Repository: [https://github.com/byrobingames/vungle](https://github.com/byrobingames/vungle)

Need help with a pull request?<br/>
[https://help.github.com/articles/creating-a-pull-request/](https://help.github.com/articles/creating-a-pull-request/)

### ANY ISSUES?

Add the issue on GitHub<br/>
Repository: [https://github.com/byrobingames/vungle/issues](https://github.com/byrobingames/vungle/issues)

Need help with creating a issue?<br/>
[https://help.github.com/articles/creating-an-issue/](https://help.github.com/articles/creating-an-issue/)

## Donate

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HKLGFCAGKBMFL)<br />

## Privacy Policy

https://www.vungle.com

## License

Author: Robin Schaafsma

The MIT License (MIT)

Copyright (c) 2014 byRobinGames [http://www.byrobin.nl](http://www.byrobin.nl)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
