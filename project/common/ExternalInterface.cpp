#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "VungleEx.h"
#include <stdio.h>

using namespace vungle;

AutoGCRoot* vungleEventHandle = 0;

#ifdef IPHONE

static void vungle_set_event_handle(value onEvent)
{
    vungleEventHandle = new AutoGCRoot(onEvent);
}
DEFINE_PRIM(vungle_set_event_handle, 1);
////
static value vungle_init(value app_id){
	init(val_string(app_id));
	return alloc_null();
}
DEFINE_PRIM(vungle_init,1);
////
static value vungle_load_ad(value placement_id){
    loadVungleAd(val_string(placement_id));
    return alloc_null();
}
DEFINE_PRIM(vungle_load_ad,1);
////
static value vungle_interstitial_show(value placement_id){
	showInterstitial(val_string(placement_id));
	return alloc_null();
}
DEFINE_PRIM(vungle_interstitial_show,1);
////
static value vungle_rewarded_show(value placement_id){
    showRewarded(val_string(placement_id));
    return alloc_null();
}
DEFINE_PRIM(vungle_rewarded_show,1);
////
static value vungle_setconsent(value isGranted){
    setVungleConsent(val_bool(isGranted));
    return alloc_null();
}
DEFINE_PRIM(vungle_setconsent,1);
////
static value vungle_getconsent(){
    return alloc_bool(getVungleConsent());
}
DEFINE_PRIM(vungle_getconsent,0);

#endif

extern "C" void vungle_main () {
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (vungle_main);

extern "C" int vungle_register_prims () { return 0; }

extern "C" void sendVungleEvent(const char* event, const char* data)
{
    printf("Send Event: %s\n", event);
    value o = alloc_empty_object();
    alloc_field(o,val_id("event"),alloc_string(event));
    alloc_field(o,val_id("data"),alloc_string(data));
    val_call1(vungleEventHandle->get(), o);
}
