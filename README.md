This outlines shader, applies outlines to 3D objects of your choice but works best on objects with rounded edges. 
It is based on the work from wikibooks (Link:https://en.wikibooks.org/wiki/Cg_Programming/Unity/Outlining_Objects) but with added features such as a silhouette covering the object when the object is behind other objects and the outlines are also visible behind other objects. It also feature the use of toggles to turn off or on both the outlines and the silhouette. 

The shader features the manipulation of variables than can be manually tweaked:
   _OUTLINES - toggles the outlines on or off a 3D-object
   _SILHOUETTE - toggles the silhouette on or off a 3D-object
 
 There is one shader for a 3D-object called **newOutlines** and another shader meant for walls and floors, or just any object you want to see the outlines through called **SurfaceShader**.\
 The script called **newOutlines** has three passes and they work like this:\
  1st pass just adds a color to an object, but it also has a stencil test, to ensure that it always renders\
  2nd pass is the outlines. The outlines move the vertices towards their normal vectors, essentially making a larger version of the object itself, and covers it with a black color. There is also a stencil test in the 2nd pass which ensures that the outlines don't occlude the object fully but only renders the outlines which are not occluding the object.\
  3rd pass features a silhouette. It also just covers the object in the same color as the outlines, but it includes a ZTest which ensures that the silhouette is only rendered when the object is behind another object.\
 \
The script called **SurfaceShader** is a script which ensures that the outlines of another object can be seen through the object which has the **SurfaceShader** script attached to it.\
   
**RUNNING THE CODE**
1. Clone the repository or download it
2. Open with Unity
3. Attach the **newOutliness** material to a given 3D-object
4. Attach the **surfaceshader** material to walls and floors
5. The outlines and the silhouette can be turned on or off 
6. The thickness of the outline can also be set using the UI
7. ![image](https://user-images.githubusercontent.com/81185865/205144683-ed21c33e-dd63-457a-915d-dd11cae676ff.png)
