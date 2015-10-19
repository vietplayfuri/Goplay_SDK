using UnityEngine;
using System.Collections;

public class UIIDPlugin {

	static public string GetUIID()
	{	
		string UIID = null;
		#if UNITY_EDITOR
		UIID = SystemInfo.deviceUniqueIdentifier;
		#elif UNITY_IOS
		UIID = IOSKeyChainBridge.KeyChainBridgeGetUIID();
		#elif UNITY_ANDROID
		UIID = SystemInfo.deviceUniqueIdentifier;
		#endif

		return UIID;
	}
}
