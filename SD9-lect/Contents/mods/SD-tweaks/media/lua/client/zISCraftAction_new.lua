Events.OnGameStart.Add(function() 
							local original_new = ISCraftAction.new
							function ISCraftAction:new(character, item, time, recipe, container, containers)
								local o = original_new(self, character, item, time, recipe, container, containers)
								
								if SDxferQOL then o.maxTime = o.maxTime * 0.35 end
								
								if self.recipe and self.recipe:getOriginalname() == "Transcribe Journal" then
									if o.maxTime < 100 then o.maxTime = 100 end
								end
								
								return o
							end
						end)