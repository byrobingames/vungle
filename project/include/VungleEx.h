#ifndef VUNGLEEX_H
#define VUNGLEEX_H


namespace vungle {
	
	
	void init(const char *__appID);
    void loadVungleAd(const char *__placementID);
    void showInterstitial(const char *__placementID);
    void showRewarded(const char *__placementID);
    void setVungleConsent(bool isGranted);
    bool getVungleConsent();
}


#endif
