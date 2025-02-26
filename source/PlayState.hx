package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import openfl.utils.Namespace;
import vlc.MP4Handler;
import vlc.MP4Sprite;

class PlayState extends FlxState
{
	var diabox:DialogueBox;

	var speechvideo:MP4Sprite;
	var realspeechvideo:FlxSprite;
	var testspeechbubble:FlxSprite;
	var speechbubbleoutline:FlxSprite;

	var camGame:FlxCamera;
	var camHud:FlxCamera;

	//characters
	var coma:Character;
	var laurie:Character;
	var luigi:Character;
	var chip:Character;
	var outer:Character;

	var topgroup:FlxTypedGroup<FlxSprite>;
	var bestgroup:FlxTypedGroup<FlxSprite>;

	override public function create()
	{
		super.create();

		startvid();

		FlxG.mouse.visible = false;

		bgColor = FlxColor.WHITE;

		camGame = new FlxCamera();
		camHud = new FlxCamera();

		camGame.bgColor = FlxColor.WHITE;
		camHud.bgColor.alpha = 0;

		FlxG.cameras.add(camGame, true);
		FlxG.cameras.add(camHud);

		diabox = new DialogueBox();
		add(diabox);

		diabox.camera = camHud;

		makeBg();

		topgroup = new FlxTypedGroup<FlxSprite>();
		topgroup.camera = camGame;
		add(topgroup);

		bestgroup = new FlxTypedGroup<FlxSprite>();
		bestgroup.camera = camGame;
		add(bestgroup);

		doCoolIntro(function():Void{
			diabox.startDialogue('intro', function():Void{
				coma.walk(FlxG.width / 1.5, 'coma', 1.5);

				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					domusiccutscene();
	
					new FlxTimer().start(5, function(tmr:FlxTimer)
					{
						coma.walk(-FlxG.width / 3.5, 'coma', 1);
					});

					new FlxTimer().start(6, function(tmr:FlxTimer)
					{
						coma.playAnimation('comaidle', 2);
	
						diabox.startDialogue('music', function():Void{
							coma.playAnimation('comaidle', 2);
							
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								diabox.startDialogue('speechbubble', function():Void{
									coma.playAnimation('comaidle', 3);
	
									removeVideoSpeechBubble();
		
									new FlxTimer().start(1.5, function(tmr:FlxTimer)
									{
										var distat = (FlxG.width / 2 - coma.width / 2) - coma.x;

										coma.walk(distat, 'coma', 1);

										cameraStuff(.8, camGame.scroll.x, camGame.scroll.y, 2, FlxEase.quartInOut);

										new FlxTimer().start(1, function(tmr:FlxTimer)
										{
											coma.playAnimation('comaidle', 3);

											diabox.startDialogue('research', function():Void{
												coma.playAnimation('comaidle', 3);

												new FlxTimer().start(.3, function(tmr:FlxTimer)
												{
													cUTSCENELAUERI();
												});
											}, function():Void{
												coma.playAnimation('comayap', 3);
											});
										});
									});
								}, function():Void{
									coma.playAnimation('comayap', 3);
								});
							});
							addVideoSpeechBubble();
						}, function():Void{
							coma.playAnimation('comayap', 3);
						});	
					});
				});
			}, function():Void{
				coma.playAnimation('comayap', 3);
			});
		});
	}

	function cUTSCENELAUERI():Void{
		FlxG.sound.play('assets/sounds/tableslam.ogg', 1);
		FlxG.sound.music.stop();

		FlxG.cameras.shake(0.01, 1);

		coma.playAnimation('comascared', 3);
		coma.flipX = true;

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			diabox.startDialogue('research2', function():Void{
				coma.playAnimation('comaconfused', 3);

				cameraStuff(1.15, -800, 0, 1.5, FlxEase.quartInOut);

				new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					FlxG.sound.play('assets/sounds/tableslam2.ogg', 1);

					new FlxTimer().start(0.01, function(tmr:FlxTimer)
					{				
						FlxG.cameras.shake(0.02, 0.15);
						FlxTween.shake(bgdoor, 0.05, .15, X);
					});

					new FlxTimer().start(0.3, function(tmr:FlxTimer)
					{				
						FlxG.cameras.shake(0.02, 0.15);
						FlxTween.shake(bgdoor, 0.05, .15, X);
					});

					new FlxTimer().start(0.65, function(tmr:FlxTimer)
					{				
						FlxG.cameras.shake(0.02, 0.15);
						FlxTween.shake(bgdoor, 0.05, .15, X);
					});

					new FlxTimer().start(2, function(tmr:FlxTimer)
					{				
						cameraStuff(.9, camGame.scroll.x, 20, 1, FlxEase.quartInOut);

						coma.x += 140;
						coma.playAnimation('comamad', 3);

						bgdoor2.visible = true;
						bgdoor.visible = false;

						FlxG.sound.play('assets/sounds/doorexplode.ogg', 1);

						laurie = new Character();
						laurie.camera = camGame;
						add(laurie);

						laurie.playAnimation('laurieidle', 3);
						laurie.x = -500;
						laurie.screenCenter(Y);
						laurie.y += 20;

						var exploder = new FlxSprite();
						exploder.frames = FlxAtlasFrames.fromSparrow('assets/images/DOOREXPLODE.png', 'assets/images/DOOREXPLODE.xml');
						exploder.animation.addByPrefix('idle', 'idle', 24, false);
						exploder.animation.play('idle');
						exploder.setGraphicSize(Std.int(exploder.width * 6));
						exploder.updateHitbox();
						exploder.camera = camGame;
						exploder.setPosition(-820, -350);
						exploder.animation.finishCallback = function(f):Void{ exploder.visible = false; };
						add(exploder);

						FlxG.sound.playMusic('assets/music/arcade.ogg', 1);

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							diabox.startDialogue('laurieintro', function():Void{
								laurie.walk(500, 'laurie', 3);
								cameraStuff(.8, camGame.scroll.x + 680, camGame.scroll.y, 3, null);

								new FlxTimer().start(3, function(tmr:FlxTimer){
									laurie.playAnimation('laurieidle', 3);
								});

								new FlxTimer().start(1.5, function(tmr:FlxTimer){
									diabox.startDialogue('comacrying', function():Void{
										coma.playAnimation('comamad', 3);
										cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);

										diabox.startDialogue('comacrying2', function():Void{
											laurie.playAnimation('laurieidle', 3);

											cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);
											diabox.startDialogue('comacrying3', function():Void{
												coma.playAnimation('comaconfused', 3);

												cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);

												diabox.startDialogue('politicslaurie1', function():Void{ //PLAY DIALOGUE
													laurie.playAnimation('laurieidle', 3);

													cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);

													var spankysprite = new FlxSprite().loadGraphic('assets/images/spankytown.png');
													spankysprite.camera = camGame;
													spankysprite.x = coma.x + coma.width / 2 - spankysprite.width / 2;
													spankysprite.y = coma.y - 100;
													spankysprite.antialiasing = true;
													add(spankysprite);

													spankysprite.alpha = 0;
													FlxTween.tween(spankysprite, {alpha: .7}, .5, {ease: FlxEase.quartInOut});

													diabox.startDialogue('politicscoma1', function():Void{ //PLAY DIALOGUE 2
														FlxTween.tween(spankysprite, {alpha: 0}, .5, {ease: FlxEase.quartInOut});

														coma.playAnimation('comaconfused', 3);

														cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);
		
														diabox.startDialogue('politicslaurie2', function():Void{ //PLAY DIALOGUE
															laurie.playAnimation('laurieidle', 3);
		
															cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);
		
															diabox.startDialogue('politicscoma2', function():Void{ //LOL dia 1
																coma.playAnimation('comaconfused', 3);

																cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);

																diabox.startDialogue('politicslaurie3', function():Void{ //PLAY DIALOGUE
																	laurie.playAnimation('laurieidle', 3);

																	cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);

																	diabox.startDialogue('politicscoma3', function():Void{ //PLAY DIALOGUE 2
																		coma.playAnimation('comaconfused', 3);

																		cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, 2.5, FlxEase.quartInOut);
																		FlxG.sound.music.fadeOut(2.5, .65);

																		new FlxTimer().start(2.5, function(tmr:FlxTimer)
																		{		
																			diabox.startDialogue('politicslaurie4', function():Void{ //PLAY DIALOGUE
																				laurie.playAnimation('lauriebored', 3);
		
																				cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, 3.5, FlxEase.quartInOut);
																				FlxG.sound.music.fadeOut(3.5, .3);

																				new FlxTimer().start(3.5, function(tmr:FlxTimer)
																				{
		
																					diabox.startDialogue('politicscoma4', function():Void{ //PLAY DIALOGUE 2
																						coma.playAnimation('comabored', 3);
																						cUTSCENELUIGI();
																					}, function():Void{
																						coma.playAnimation('comaconfusedtalk', 3);
																					});
																				});
																		}, function():Void{
																			laurie.playAnimation('laurieyap', 3);
																		});	
																	});												
																}, function():Void{
																	coma.playAnimation('comashock', 3);
																});
															}, function():Void{
																laurie.playAnimation('laurieyap', 3);
															});
															}, function():Void{
																coma.playAnimation('comashock', 3);
															});
		
														}, function():Void{
															laurie.playAnimation('laurieyap', 3);
														});													
													}, function():Void{
														coma.playAnimation('comashock', 3);
													});
												}, function():Void{
													laurie.playAnimation('laurieyap', 3);
												});
											}, function():Void{
												coma.playAnimation('comaconfusedtalk', 3);
											});
										}, function():Void{
											laurie.playAnimation('laurieyap', 3);
										});
									}, function():Void{
										coma.playAnimation('comamadtalk', 3);
									});
								});
							}, function():Void{
								laurie.playAnimation('laurieyap', 4);
							});
						});
					});
				});
			}, function():Void{
				coma.playAnimation('comaconfusedtalk', 3);
			});
		});
	}

	function cUTSCENELUIGI():Void{
		FlxG.sound.music.fadeOut(4, 0);
		cameraStuff(1, camGame.scroll.x - 50, camGame.scroll.y, 4, FlxEase.quartInOut);

		new FlxTimer().start(5, function(tmr:FlxTimer)
		{	
			diabox.startDialogue('luigiintro', function():Void{
				laurie.playAnimation('lauriesurprise', 3);
	
				coma.playAnimation('comascared', 3);
				coma.flipX = false;
	
				luigi = new Character();
				luigi.camera = camGame;
				add(luigi); 
				
				luigi.playAnimation('luigiidle', 3);
				luigi.x = 1200;
				luigi.screenCenter(Y);
				luigi.y += -10;
				luigi.flipX = true;

				FlxG.sound.playMusic('assets/music/glisp.ogg', .8);
				FlxG.sound.play('assets/sounds/orchestra.ogg', 1);

				camGame.shake(0.05, 0.15);

				new FlxTimer().start(1.3, function(tmr:FlxTimer)
				{
					cameraStuff(0.9, camGame.scroll.x + 580, camGame.scroll.y, 3, FlxEase.quartInOut);

					new FlxTimer().start(3, function(tmr:FlxTimer)
					{
						diabox.startDialogue('luigi1', function():Void{
							coma.playAnimation('comaconfused', 3);

							new FlxTimer().start(.2, function(tmr:FlxTimer)
							{
								cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);

								var funnyluigi = new Character();
								funnyluigi.camera = camGame;
								funnyluigi.flipX = true;
								add(funnyluigi); 

								funnyluigi.playAnimation('luigilmao', 1);
								funnyluigi.setPosition(luigi.x, luigi.y);

								funnyluigi.alpha = 0;

								FlxTween.tween(luigi, {alpha: 0}, 6);
								FlxTween.tween(funnyluigi, {alpha: 1}, 6, {onComplete: function(f):Void{
									cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);
									diabox.startDialogue('luigi2', function():Void{
										coma.playAnimation('comamad', 3);

										cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);

										diabox.startDialogue('luigi3', function():Void{
											luigi.playAnimation('luigiidle', 3);

											cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);

											diabox.startDialogue('luigi4', function():Void{ //everything under here needs to be fixed
												coma.playAnimation('comaconfused', 3);

												cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);

												diabox.startDialogue('luigi5', function():Void{
													luigi.playAnimation('luigiidle', 3);

													cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);

													diabox.startDialogue('luigi6', function():Void{
														coma.playAnimation('comaidle', 3);

														cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);
		
														diabox.startDialogue('luigi7', function():Void{
															luigi.playAnimation('luigiidle', 3);
		
															cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);
		
															diabox.startDialogue('luigi8', function():Void{
																coma.playAnimation('comaidle', 3);

																cameraStuff(0.7, camGame.scroll.x + 430, camGame.scroll.y - 100, 2, FlxEase.quartOut);
																FlxG.sound.music.fadeOut(4, 0);

																diabox.startDialogue('luigi9', function():Void{
																	luigi.playAnimation('luigiidle', 3);
																	cUTSCENECHIP();
																}, function():Void{
																	luigi.playAnimation('luigiyap', 3);
																});
															}, function():Void{
																coma.playAnimation('comayap', 3);
															});
														}, function():Void{
															luigi.playAnimation('luigiyap', 3);
														});													
													}, function():Void{
														coma.playAnimation('comayap', 3);
													});
												}, function():Void{
													luigi.playAnimation('luigiyap', 3);
												});
											}, function():Void{
												coma.playAnimation('comaconfusedtalk', 3);
											});
										}, function():Void{
											luigi.playAnimation('luigiyap', 3);
											funnyluigi.alpha = 0;
											luigi.alpha = 1;
										});

									}, function():Void{
										coma.playAnimation('comamadtalk', 3);
									});
								}});

							});
						}, function():Void{
							coma.playAnimation('comaconfusedtalk', 3);
						});
					});
				});
			});
		});
	}

	function cUTSCENECHIP():Void{
		chip.playAnimation('chipfast', 10);
		chip.setPosition(luigi.x + 5000, luigi.y);

		FlxG.sound.play('assets/sounds/chiprun.ogg', 1);

		var group = new FlxTypedGroup<FlxSprite>();
		add(group);

		new FlxTimer().start(1.86, function(tmr:FlxTimer)
		{
			FlxG.sound.play('assets/sounds/doorexplode.ogg', 1);

			var exploder = new FlxSprite();
			exploder.frames = FlxAtlasFrames.fromSparrow('assets/images/DOOREXPLODE.png', 'assets/images/DOOREXPLODE.xml');
			exploder.animation.addByPrefix('idle', 'idle', 35, false);
			exploder.animation.play('idle');
			exploder.setGraphicSize(Std.int(exploder.width * 6));
			exploder.updateHitbox();
			exploder.camera = camGame;
			exploder.setPosition(chip.x - 800, -350);
			exploder.animation.finishCallback = function(f):Void{ exploder.visible = false; };
			add(exploder);

			bgdoorright1.visible = false;
			bgdoorright2.visible = true;

			remove(chip);
			group.add(chip);
		});

		FlxTween.tween(chip, {x: luigi.x + 50}, 2, {onComplete: function(f):Void{
			FlxG.sound.play('assets/sounds/chipkilling.ogg', 1);

			camGame.flash();
			chip.playAnimation('chipidle', 3);
			coma.playAnimation('comalook', 3);
			chip.flipX = true;
			luigi.playAnimation('luigidie', 2);
			luigi.velocity.x = -500;
			luigi.velocity.y = - 1500;

			new FlxTimer().start(.4, function(tmr:FlxTimer)
			{
				coma.flipX = true;
			});
	
			laurie.x -= 200;
			cameraStuff(0.85, camGame.scroll.x - 1000, camGame.scroll.y, 3, FlxEase.quartInOut);

			new FlxTimer().start(1.65, function(tmr:FlxTimer)
			{
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					luigi.velocity.set(0, 0);
					luigi.setPosition(laurie.x + 350, -1000);

					FlxTween.tween(luigi, {y: laurie.y}, .6, {onComplete: function(f):Void{
						FlxG.sound.play('assets/sounds/luigiground.ogg', 1);

						luigi.playAnimation('luigihurt', 3);
						laurie.playAnimation('lauriehelp', 3);
						coma.playAnimation('comahelp', 3);
						coma.y = laurie.y;
						camGame.shake(0.09, 0.15);

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							FlxG.sound.playMusic('assets/music/gauntlet1.ogg', 0);
							FlxG.sound.music.fadeIn(3, 0, .8);

							coma.playAnimation('comamad', 3);
							coma.flipX = false;

							chip.y += 80;
							chip.x += 200;
							chip.walk(-400, 'chip', 3);
							cameraStuff(.8, camGame.scroll.x + 590, camGame.scroll.y + 180, 3, FlxEase.quartInOut);

							new FlxTimer().start(3, function(tmr:FlxTimer)
							{
								chip.playAnimation('chipidle', 3);

								diabox.startDialogue('chip1', function():Void{
									chip.playAnimation('chipidle', 3);
									cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);
									diabox.startDialogue('chip2', function():Void{
										coma.playAnimation('comamad', 3);
										cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);
										diabox.startDialogue('chip3', function():Void{
											chip.playAnimation('chipidle', 3);
											cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);
											diabox.startDialogue('chip4', function():Void{
												coma.playAnimation('comamad', 3);
												cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);
												diabox.startDialogue('chip5', function():Void{ //holy shit save us
													chip.playAnimation('chipidle', 3);
													cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);
													diabox.startDialogue('chip6', function():Void{
														coma.playAnimation('comamad', 3);
														cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);
														diabox.startDialogue('chip7', function():Void{
															chip.playAnimation('chipidle', 3);
															cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);
															diabox.startDialogue('chip8', function():Void{
																coma.playAnimation('comamad', 3);
																var camx = camGame.scroll.x;
																var camy = camGame.scroll.y;
																var camzoom = camGame.zoom;

																cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);
																diabox.startDialogue('chip9', function():Void{
																	chip.playAnimation('chipidle', 3);

																	cameraStuff(1.7, camGame.scroll.x + 200, camGame.y + 40, 2, FlxEase.quartInOut);

																	new FlxTimer().start(3, function(tmr:FlxTimer)
																	{
																		coma.playAnimation('comadisturbed', 3);
																		luigi.playAnimation('luigidead', 3, 2000);
																		luigi.flipX = false;
																		luigi.x -= 200;
																		laurie.playAnimation('lauriemourn', 3);

																		trace('DECAPITATION');

																		chip.visible = false;

																		camGame.shake(0.09, 0.15);
																		camGame.flash();

																		FlxG.sound.play('assets/sounds/cool0.ogg', .5);
																		FlxG.sound.music.stop();
																		
																		FlxG.sound.play('assets/sounds/chipdies.ogg', .5);

																		for(i in 0...6){
																			var corpse = new FlxSprite().loadGraphic('assets/images/chipcorpse' + (i + 1) + '.png');
																			corpse.setGraphicSize(chip.width, chip.height);
																			corpse.updateHitbox();
																			corpse.setPosition(chip.x, chip.y);
																			corpse.camera = camGame;
																			group.add(corpse);

																			FlxTween.angle(corpse, 0,  FlxG.random.float(-180, 180), 2);
																			FlxTween.tween(corpse, {y: FlxG.height + 500}, FlxG.random.float(0.9, 1.4), {ease: FlxEase.backIn});
																		}

																		new FlxTimer().start(3.5, function(tmr:FlxTimer)
																		{
																			cameraStuff(camzoom, camx - 600, camy, 4, FlxEase.quartInOut);

																			new FlxTimer().start(6, function(tmr:FlxTimer)
																			{
																				oUTERCUTSCENE();
																			});
																		});
																	});
																}, function():Void{
																	chip.playAnimation('chipyap', 3);
																});
															}, function():Void{
																coma.playAnimation('comamadtalk', 3);
															});
														}, function():Void{
															chip.playAnimation('chipyap', 3);
														});
													}, function():Void{
														coma.playAnimation('comamadtalk', 3);
													});
												}, function():Void{
													chip.playAnimation('chipyap', 3);
												});
											}, function():Void{
												coma.playAnimation('comamadtalk', 3);
											});
										}, function():Void{
											chip.playAnimation('chipyap', 3);
										});
									}, function():Void{
										coma.playAnimation('comamadtalk', 3);
									});
								}, function():Void{
									chip.playAnimation('chipyap', 3);
								});

								//cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);
							});
						});
					}});
				});
			});
		}});

	}

	function oUTERCUTSCENE():Void{		
		outer = new Character();
		outer.camera = camGame;
		outer.flipX = !outer.flipX;
		topgroup.add(outer);

		outer.playAnimation('outerangel', 10);
		outer.y = -700;
		outer.x = coma.x + 700;

		diabox.startDialogue('outer1', function():Void{
			cameraStuff(.7, camGame.scroll.x + 600, camGame.scroll.y - 80, 1.5, FlxEase.backInOut);

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.sound.play('assets/sounds/angel.ogg', 1);			
				FlxTween.tween(outer, {y: coma.y}, 6.5, {onComplete: function(sd):Void{
					outer.playAnimation('outeridle', 3);
					diabox.startDialogue('outer2', function():Void{
						outer.playAnimation('outerwave', 3);
						cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);

						new FlxTimer().start(2, function(tmr:FlxTimer)
						{
							cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);

							diabox.startDialogue('outer3', function():Void{
								outer.playAnimation('outerwave', 3);
		
								cameraStuff(camGame.zoom, camGame.scroll.x - 100, camGame.scroll.y, .5, FlxEase.quartOut);

								new FlxTimer().start(2, function(tmr:FlxTimer)
								{
									cameraStuff(camGame.zoom, camGame.scroll.x + 100, camGame.scroll.y, .5, FlxEase.quartOut);

									diabox.startDialogue('outer4', function():Void{
										outer.playAnimation('outerbomb', 3);

										FlxG.sound.play('assets/sounds/tick.ogg', .8);

										new FlxTimer().start(6.5, function(tmr:FlxTimer)
										{
											FlxG.sound.playMusic('assets/music/fragment.ogg', 1);

											FlxG.sound.play('assets/sounds/doorexplode.ogg', 1);

											var exploder = new FlxSprite();
											exploder.frames = FlxAtlasFrames.fromSparrow('assets/images/DOOREXPLODE.png', 'assets/images/DOOREXPLODE.xml');
											exploder.animation.addByPrefix('idle', 'idle', 35, false);
											exploder.animation.play('idle');
											exploder.setGraphicSize(Std.int(exploder.width * 20));
											exploder.updateHitbox();
											exploder.camera = camHud;
											exploder.screenCenter();
											exploder.animation.finishCallback = function(f):Void{ exploder.visible = false; };
											add(exploder);

											bgspace.visible = true;

											cameraStuff(.5, camGame.scroll.x - 200, camGame.scroll.y + 70, 2, FlxEase.quartInOut);

											coma.angularVelocity = FlxG.random.float(15, 100);
											laurie.angularVelocity = FlxG.random.float(15, 100);
											luigi.angularVelocity = FlxG.random.float(15, 100);
											outer.angularVelocity = FlxG.random.float(15, 100);

											luigi.velocity.y = -40;

											laurie.playAnimation('lauriestruggle', 6);
											coma.playAnimation('comapissed', 3);
											outer.playAnimation('outeridle', 3);

											new FlxTimer().start(4, function(tmr:FlxTimer)
											{
												diabox.startDialogue('outer5', function():Void{
													outer.playAnimation('outeridle', 3);

													new FlxTimer().start(4, function(tmr:FlxTimer)
													{
														diabox.startDialogue('outer6', function():Void{
															outer.playAnimation('outerawkward', 3);

															remove(coma);
															bestgroup.add(coma);

															remove(laurie);
															topgroup.add(laurie);

															FlxTween.tween(outer.velocity, {x: 200}, 5, {ease: FlxEase.quartIn});
															FlxTween.tween(laurie.velocity, {x: -200}, 5, {ease: FlxEase.quartIn});

															var black = new FlxSprite().makeGraphic(5000, 5000, FlxColor.BLACK);
															black.screenCenter();
															black.alpha = 0;
															topgroup.add(black);

															FlxTween.tween(black, {alpha: .7}, 7);

															cameraStuff(camGame.zoom * .9, camGame.scroll.x, camGame.scroll.y, 7, null);

															new FlxTimer().start(9, function(tmr:FlxTimer)
															{
																diabox.startDialogue('comahasasadlittlemeltdown', function():Void{
																	coma.playAnimation('comacontent', 3);

																	new FlxTimer().start(2, function(tmr:FlxTimer)
																	{
																		cameraStuff(camGame.zoom * 1.6, camGame.scroll.x - 450, camGame.scroll.y, 3, FlxEase.quartInOut);

																		new FlxTimer().start(3.5, function(tmr:FlxTimer)
																		{
																			var thetext = new FlxText(70, FlxG.height, 600 ,"The History of Nothing according to Coma\n\nA sequel to:\nThe History of the Growth in Social Media according to Coma\n\nThanks to my friends for supporting me while making this.\nI had a lot of fun.\n\nEven though I feel very very burnt out at the moment.\n(I made the whole game in 2 weeks)\n\nThanks to my friends for being in this game!!\n(Smalarie, Luigi, Chip and 0uter)\n\nI did all the programming, art and writing.\n\nThe sound effects are taken from multiple places, im not a sound designer sadly.\n\nMusic Used: \n\nPlaying Favorites - Kyzroen\nHazy Lotteries - Kyzroen\nking of bugs - GRAH! Studios\nCheesy Puffs (Happy) - GRAH! Studios\nShiny Glass (Fragments) - Kyzroen\n\nAll of the music is from me and 0uters game OCRPG\n(WISHLIST IT ON STEAM!!)\n\n\n\nAnyway...\n\nThe End\n\n\n\n\n\n\n\nBye :-)", 45);
																			thetext.setFormat('assets/fonts/andy.ttf', 35, 0xFFFFFFFF, CENTER);
																			thetext.antialiasing = true;
																			thetext.camera = camHud;
																			add(thetext);

																			FlxTween.tween(thetext, {y: -thetext.height}, 55, {onComplete: function(s):Void{
																				coma.playAnimation('comawaver', 4);

																				var tran = new CircleTransition('out', 3.5);
																				tran.camera = camHud;
																				add(tran);

																				FlxG.sound.music.fadeOut(3.5, 0);

																				new FlxTimer().start(5, function(tmr:FlxTimer)
																				{
																					Sys.exit(0);
																				});
																			}});

																		});
																	});
																}, function():Void{
																	coma.playAnimation('comapissedtalk', 3);
																});
															});
														}, function():Void{
															outer.playAnimation('outerawkwardtalk', 3);
														});
													});
												}, function():Void{
													outer.playAnimation('outertalk', 3);
												});
											});
										});
									}, function():Void{
										outer.playAnimation('outertalk', 3);
									});
								});
							}, function():Void{
								outer.playAnimation('outertalk', 3);
							});
						});
					}, function():Void{
						outer.playAnimation('outertalk', 3);
					});
				}});
			});
		});
	}

	function addVideoSpeechBubble():Void{
		testspeechbubble = new FlxSprite().loadGraphic('assets/images/speechbubble.png');
				
		speechbubbleoutline = new FlxSprite().loadGraphic('assets/images/speechbubbleoutline.png');
		//add(speechvideo);

		realspeechvideo = new FlxSprite(0, -400);
		realspeechvideo.camera = camGame;
		add(realspeechvideo);

		add(speechbubbleoutline);
		speechbubbleoutline.camera = camGame;

		FlxTween.tween(realspeechvideo, {y: 0}, 2, {ease: FlxEase.backOut});
	}

	function startvid():Void{
		speechvideo = new MP4Sprite(300,0,1066,590,true);
		speechvideo.playVideo('assets/videos/speech.mp4', false, false);
		speechvideo.finishCallback = startvid;
	}

	function removeVideoSpeechBubble():Void{
		FlxTween.tween(realspeechvideo, {y: -500}, 2, {ease: FlxEase.backIn, onComplete: function(f):Void{
			realspeechvideo.visible = false;
			speechbubbleoutline.visible = false;
		}});
	}

	function domusiccutscene():Void{
		FlxG.sound.play('assets/sounds/crickets.ogg', .4);
		FlxG.sound.play('assets/sounds/musicturningon.ogg', 1);

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			makeMusicParticle(8);

			camGame.shake(0.05, 0.15);
			camGame.zoom -= 0.01;
		});

		new FlxTimer().start(.7, function(tmr:FlxTimer)
		{
			makeMusicParticle(4);

			camGame.shake(0.025, 0.15);
			camGame.zoom -= 0.01;
		});

		new FlxTimer().start(1.225, function(tmr:FlxTimer)
		{
			makeMusicParticle(2);

			camGame.shake(0.025, 0.15);

			camGame.zoom -= 0.01;
		});

		new FlxTimer().start(3.4, function(tmr:FlxTimer)
		{
			FlxG.sound.play('assets/sounds/recordScratch.ogg', 1);
			FlxG.sound.playMusic('assets/music/charSelectNew.ogg', .8);

			FlxTween.tween(camGame, {zoom: 1}, 1, {ease:FlxEase.quartOut});
		});
	}

	function makeMusicParticle(theamount:Int):Void{
		for(i in 0...theamount){
			var particle = new FlxSprite(FlxG.width + 30, FlxG.random.float(0, FlxG.height /2)).loadGraphic('assets/images/musicparticle' + FlxG.random.int(1,3) + '.png');
			particle.velocity.set(FlxG.random.float(-300, -800), 400);
			particle.angle = FlxG.random.float(0,360);
			particle.angularVelocity = (FlxG.random.float(0, -300));
			particle.camera = camGame;
			add(particle);	
		}
	}

	var tempbgintro:FlxSprite;
	var nicepurplecoma:FlxSprite;
	var bottomtext:FlxText;

	var beginning:Bool = false;

	var readyfunc:Void -> Void;

	function doCoolIntro(func:Void -> Void){
		beginning = true;

		tempbgintro = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF3F003A, false);
		add(tempbgintro);

		nicepurplecoma = new FlxSprite().loadGraphic('assets/images/comabefore.png');
		nicepurplecoma.setGraphicSize(Std.int(nicepurplecoma.width * .7));
		nicepurplecoma.updateHitbox();
		nicepurplecoma.screenCenter();
		add(nicepurplecoma);

		bottomtext = new FlxText(0, 650, 0,"Press ANYTHING to start!! Yes.. i mean ANYTHING..", 25);
		bottomtext.setFormat('assets/fonts/andy.ttf', 25, 0xFF5B0053, CENTER);
		bottomtext.screenCenter(X);
		bottomtext.antialiasing = true;
		add(bottomtext);

		readyfunc = func;
	}

	function doCoolIntroPartTwo():Void{
		beginning = false;

		bottomtext.text = 'THANKS FOR PRESSING IT - BYEE';
		bottomtext.screenCenter(X);

		FlxTween.tween(bottomtext, {y: FlxG.height}, 1.5, {onComplete: function(f):Void{
			bottomtext.destroy();
		}});

		FlxG.cameras.shake(0.015, 0.15);

		for(i in 0...6){
			var silly = new FlxSprite().loadGraphic('assets/images/star' + FlxG.random.int(1,4) + '.png');
			silly.screenCenter();
			silly.setPosition(silly.x += FlxG.random.int(-100, 100), silly.y += FlxG.random.int(-100, 100));
			silly.alpha = 0;
			add(silly);

			silly.velocity.y = FlxG.random.float(-50, -300);
			silly.angularVelocity = FlxG.random.float(-100, 100);

			FlxTween.tween(silly, {alpha: 1}, .3, {ease:FlxEase.quartOut, startDelay: .1 * i, onComplete: function(f):Void{
				FlxTween.tween(silly, {alpha: 0}, .3, {ease:FlxEase.quartIn, startDelay: .5, onComplete: function(f):Void{
					silly.destroy();
				}});
			}});
		}

		new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.cameras.shake(0.01, 2.3);
				FlxTween.tween(FlxG.camera, {zoom: 1.5}, 2, {onComplete: function(f):Void{
					tempbgintro.destroy();
					nicepurplecoma.destroy();

					FlxG.cameras.flash();

					coma = new Character();
					coma.camera = camGame;
					add(coma);

					coma.playAnimation('comawaver', 4);
					coma.screenCenter();

					FlxTween.tween(FlxG.camera, {zoom: 1}, 1.5, {onComplete: function(f):Void{
						readyfunc();
					}});
				}});
			});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if(testspeechbubble != null && speechvideo != null && realspeechvideo != null){
			FlxSpriteUtil.alphaMaskFlxSprite(speechvideo, testspeechbubble, realspeechvideo);
			speechbubbleoutline.setPosition(realspeechvideo.x, realspeechvideo.y);
		}

		if(beginning){
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if(FlxG.keys.justReleased.ANY || gamepad != null && gamepad.justPressed.ANY){
				doCoolIntroPartTwo();
			}
		}
	}

	var bgmain:FlxSprite;
	var bgdoor:FlxSprite;
	var bgdoor2:FlxSprite;
	var bgdoorright1:FlxSprite;
	var bgdoorright2:FlxSprite;
	var bgspace:FlxBackdrop;

	function makeBg():Void{
		chip = new Character();
		chip.camera = camGame;
		add(chip);

		bgdoorright1 = new FlxSprite().loadGraphic('assets/images/bg_rightdoor1.png');
		bgdoorright1.antialiasing = true;
		bgdoorright1.camera = camGame;
		bgdoorright1.setGraphicSize(Std.int(bgdoorright1.width * 1.2));
		bgdoorright1.updateHitbox();
		bgdoorright1.screenCenter();
		bgdoorright1.y -= 140;
		add(bgdoorright1);

		bgmain = new FlxSprite().loadGraphic('assets/images/bg_main.png');
		bgmain.antialiasing = true;
		bgmain.camera = camGame;
		bgmain.setGraphicSize(Std.int(bgmain.width * 1.2));
		bgmain.updateHitbox();
		bgmain.screenCenter();
		bgmain.y -= 140;
		add(bgmain);

		bgdoor = new FlxSprite().loadGraphic('assets/images/bg_door1.png');
		bgdoor.antialiasing = true;
		bgdoor.camera = camGame;
		bgdoor.setGraphicSize(Std.int(bgdoor.width * 1.2));
		bgdoor.updateHitbox();
		bgdoor.screenCenter();
		bgdoor.y -= 140;
		add(bgdoor);

		bgdoor2 = new FlxSprite().loadGraphic('assets/images/bg_door2.png');
		bgdoor2.antialiasing = true;
		bgdoor2.camera = camGame;
		bgdoor2.setGraphicSize(Std.int(bgdoor2.width * 1.2));
		bgdoor2.updateHitbox();
		bgdoor2.screenCenter();
		bgdoor2.y -= 140;
		bgdoor2.visible = false;
		add(bgdoor2);

		bgdoorright2 = new FlxSprite().loadGraphic('assets/images/bg_rightdoor2.png');
		bgdoorright2.antialiasing = true;
		bgdoorright2.camera = camGame;
		bgdoorright2.setGraphicSize(Std.int(bgdoorright2.width * 1.2));
		bgdoorright2.updateHitbox();
		bgdoorright2.screenCenter();
		bgdoorright2.y -= 140;
		bgdoorright2.visible = false;
		add(bgdoorright2);

		bgmain.x += 225;
		bgdoor.x += 225;
		bgdoor2.x += 225;
		bgdoorright1.x += 225;
		bgdoorright2.x += 225;

		bgspace = new FlxBackdrop('assets/images/bg_space.png');
		bgspace.velocity.set(50, 50);
		bgspace.camera = camGame;
		bgspace.visible = false;
		add(bgspace);
	}

	function cameraStuff(zoom:Float, x:Float, y:Float, time:Float, theease:Null<EaseFunction>):Void{
		FlxTween.tween(camGame, {zoom: zoom}, time, {ease:theease});
		FlxTween.tween(camGame.scroll, {x: x, y: y}, time, {ease:theease});
	}
}
 