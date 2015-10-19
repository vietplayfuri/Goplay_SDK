using UnityEngine;
using System.Collections;
using GoPlaySDK;

public class sprite : MonoBehaviour {

	void Start () {
		GoPlaySdk.Instance.OnLogin += HandleOnLogin;
		GoPlaySdk.Instance.Login("davis123","123456");
	}
	
	// Update is called once per frame
	void HandleOnLogin (IResult result) {
		print ("yes");
	}
}
