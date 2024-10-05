package alternativa.physics.rigid.primitives {

	import alternativa.physics.altphysics;
	import alternativa.physics.collision.primitives.CollisionBox;
	import alternativa.physics.rigid.Body;
	import alternativa.physics.types.Matrix3;
	import alternativa.physics.types.Vector3;

	use namespace altphysics;	
	
	/**
	 * 
	 */
	public class RigidBox extends Body {
		
		/**
		 * 
		 * @param halfSize
		 * @param mass
		 */
		public function RigidBox(halfSize:Vector3, mass:Number) {
			super(0, Matrix3.ZERO);
			addCollisionPrimitive(new CollisionBox(halfSize, 1));
			setParams(halfSize, mass);
		}
		
		/**
		 * @param halfSize
		 * @param mass
		 */
		public function setParams(halfSize:Vector3, mass:Number):void {
			/* Момент инерции бокса:
			
			  m*(hy*hy + hz*hz)/3            0                     0
			           0            m*(hz*hz + hx*hx)/3            0
			           0                     0            m*(hx*hx + hy*hy)/3
			           
			 hx, hy, hz -- половина размера бокса вдоль соответствующей оси
			*/
			invInertia.copy(Matrix3.ZERO);
			if (mass == Infinity)	invMass = 0;
			else {
				invMass = 1/mass;
				var xx:Number = halfSize.x*halfSize.x;
				var yy:Number = halfSize.y*halfSize.y;
				var zz:Number = halfSize.z*halfSize.z;
				invInertia.a = 3*invMass/(yy + zz);
				invInertia.f = 3*invMass/(zz + xx);
				invInertia.k = 3*invMass/(xx + yy);
			}
			var prim:CollisionBox = collisionPrimitives[0] as CollisionBox;
			prim.hs.vCopy(halfSize);
		}
		
	}
}