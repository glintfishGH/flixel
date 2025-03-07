package flixel.ui;

import flixel.FlxSprite;
import flixel.ui.FlxButton;
import openfl.display.BitmapData;
import massive.munit.Assert;

class FlxButtonTest extends FlxTest
{
	var button:FlxButton;

	#if !js // assets (including the FlxButton default one) don't work in openfl-html5 tests
	@Before
	function before()
	{
		button = new FlxButton();
		destroyable = button;
	}

	@Test
	function testDefaultStatusAnimations()
	{
		assertStatusAnimationsExist();
	}

	@Test
	function testLoadGraphicStatusAnimations()
	{
		var graphic = new BitmapData(3, 1);
		button.loadGraphic(graphic, true, 1, 1);

		assertStatusAnimationsExist();
	}

	@Test
	function testLoadGraphicFromSpriteStatusAnimations()
	{
		var sprite = new FlxSprite();
		var graphic = new BitmapData(3, 1);
		sprite.loadGraphic(graphic, true, 1, 1);

		button.loadGraphicFromSprite(sprite);

		assertStatusAnimationsExist();
	}

	function assertStatusAnimationsExist()
	{
		Assert.isNotNull(button.animation.getByName(NORMAL.toString()));
		Assert.isNotNull(button.animation.getByName(HIGHLIGHT.toString()));
		Assert.isNotNull(button.animation.getByName(PRESSED.toString()));
	}

	@Test // #1479
	function testSetTextTwice()
	{
		setAndAssertText("Test");
		setAndAssertText("Test2");
	}

	@Test
	function testSetTextNull()
	{
		setAndAssertText(null);
	}

	@Test // #1818
	function testHighlightStatusInUpperLeftCorner()
	{
		FlxG.state.add(button);

		button.setPosition();
		step(1);
		Assert.areEqual(HIGHLIGHT, button.status);

		FlxG.state.remove(button);
	}

	@Test // #1365
	function testTriggerAnimationOnce()
	{
		button.x = 1; // put it slightly to the right of the cursor so that it isn't highlighted by default
		button.animation.add("normal", [for (i in 0...4) 0], 30, false);
		FlxG.state.add(button);
		step(2);

		Assert.areEqual(NORMAL, button.status);
		Assert.areEqual("normal", button.animation.curAnim.name);
		Assert.areEqual(false, button.animation.finished);
		step(10);
		Assert.areEqual("normal", button.animation.curAnim.name);
		Assert.areEqual(true, button.animation.finished);
		FlxG.state.remove(button);
	}

	function setAndAssertText(text:String)
	{
		button.text = text;
		Assert.areEqual(text, button.text);
		if (button.label != null)
			Assert.areEqual(text, button.label.text);
	}
	#end
}
