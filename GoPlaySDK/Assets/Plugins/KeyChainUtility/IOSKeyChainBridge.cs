using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class IOSKeyChainBridge {
	
	#if UNITY_IOS
	[DllImport ("__Internal")]
	private static extern string _KeyChainBridgeGetUIID ();

	public static string KeyChainBridgeGetUIID (){
		return _KeyChainBridgeGetUIID ();
	}

	#endif
}
