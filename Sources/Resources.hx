package ;
import kha.Assets;
import kha.Blob;
import kha.Image;
import kha.Sound;

/**
 * ...
 * @author Joaquin
 */
class Resources
{

	public function new() 
	{
		
	}
	
		private var mAnimationsResources:Array<String> = new Array();
		private var mImageResources:Array<String> = new Array();
		private var mSoundResources:Array<String> = new Array();
		
		private var mTextureDimesion:Array<Point> = new Array();
		private var mDataResources:Array<String> = new Array();
		private var mAnimationsLoaded:Int = 0;
		private var mImagesLoaded:Int = 0;
		private var mSoundsLoaded:Int = 0;
		private var mDataLoaded:Int = 0;
		private var mOnFinish:Void->Void;
		public function addAnimation(aAnimation:String,textureId:Int=1):Void
		{
			
		}
		public function addImage(aImage:String):Void
		{
			mImageResources.push(aImage);
		}
		public function addSound(aSound:String):Void
		{
			mSoundResources.push(aSound);
		}
		
		public function load(onFinish:Void->Void):Void
		{
			mOnFinish = onFinish;
		
			for (image in mImageResources)
			{
				Assets.loadImage(image, onImageLoad);
			}
			for (sound in mSoundResources) 
			{
				Assets.loadSound(sound, onSoundLoad);
			}
			for (data in mDataResources)
			{
				Assets.loadBlob(data, function(b:Blob) {++mDataLoaded; checkFinishLoading();} );
			}
		}
		
		
		
		public function checkFinishLoading()
		{
			if (isAllLoaded())
			{
				mOnFinish();
			}
		}
		
		private function onImageLoad(aImage:Image):Void
		{
       
			++mImagesLoaded;
			checkFinishLoading();
		}
		private function onSoundLoad(aSound:Sound):Void
		{
			aSound.uncompress(function() {
				++mSoundsLoaded;
			checkFinishLoading();});
			
		}
		public function unload():Void
		{
			
			for (sound in mSoundResources) 
			{
				Reflect.callMethod(Assets.sounds, Reflect.field(Assets.sounds, sound + "Unload"), []);
			}
			mSoundResources.splice(0, mSoundResources.length);
			mAnimationsLoaded = 0;
			mSoundsLoaded = 0;
			mImagesLoaded = 0;
		}
		public function isAllLoaded():Bool
		{
			return mAnimationsResources.length == mAnimationsLoaded &&
				mImageResources.length == mImagesLoaded &&
				mSoundResources.length == mSoundsLoaded &&
				mDataResources.length == mDataLoaded;
		}
		
		public function addData(aName:String) 
		{
			mDataResources.push(aName);
		}
}