using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour {
	
	public float speed;

	void OnDrawGizmos()
	{
		var angle = this.transform.localEulerAngles;
		angle.y -= speed;
		this.transform.localEulerAngles = angle;
	}
}
