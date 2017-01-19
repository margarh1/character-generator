# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Trait.destroy_all
Skill.destroy_all
Proficiency.destroy_all
PersonalityTrait.destroy_all
Ideal.destroy_all
Bond.destroy_all
Flaw.destroy_all

traits = ['Strength', 'Dexterity', 'Constitution', 'Intelligence', 'Wisdom', 'Charisma']
traits.each {|trait| Trait.create({name: trait})}

skills = [{name: 'Acrobatics', trait: 'Dexterity'},
          {name: 'Animal Handling', trait: 'Wisdom'},
          {name: 'Arcana', trait: 'Intelligence'},
          {name: 'Athletics', trait: 'Strength'},
          {name: 'Deception', trait: 'Charisma'},
          {name: 'History', trait: 'Intelligence'},
          {name: 'Insight', trait: 'Wisdom'},
          {name: 'Intimidation', trait: 'Charisma'},
          {name: 'Investigation', trait: 'Intelligence'},
          {name: 'Medicine', trait: 'Wisdom'},
          {name: 'Nature', trait: 'Intelligence'},
          {name: 'Perception', trait: 'Wisdom'},
          {name: 'Performance', trait: 'Charisma'},
          {name: 'Persuasion', trait: 'Charisma'},
          {name: 'Religion', trait: 'Intelligence'},
          {name: 'Sleight of Hand', trait: 'Dexterity'},
          {name: 'Stealth', trait: 'Dexterity'},
          {name: 'Survival', trait: 'Wisdom'}
        ]
skills.each {|skill| Skill.create(skill)}

armor_proficiencies = ['Light armor', 'Medium armor', 'Heavy armor', 'Shield']
simple_melee = ['Club', 'Dagger', 'Greatclub', 'Handaxe', 'Javelin', 'Light Hammer',
                  'Mace', 'Quarterstaff', 'Sickle', 'Spear', 'Unarmed strike']
simple_ranged = ['Crossbow, light', 'Dart', 'Shortbow', 'Sling']
martial_melee = ['Battleaxe', 'Flail', 'Glaive', 'Greataxe', 'Greatsword', 'Halberd',
                'Lance', 'Longsword', 'Maul', 'Morningstar', 'Pike', 'Rapier', 'Scimitar',
                'Shortsword', 'Trident', 'War pick', 'Warhammer', 'Whip']
martial_ranged = ['Blowgun', 'Crossbow, hand', 'Crossbow, heavy', 'Longbow', 'Net']
tools = ["Alchemist's supplies", "Brewer's supplies", "Calligrapher's supplies",
          "Carpenter's tools", "Cartographer's tools", "Cobbler's tools", "Cook's utensils",
          "Glassblower's tools", "Jeweler's tools", "Leatherworker's tools", "Mason's tools",
          "Painter's supplies", "Potter's tools", "Smith's tools", "Tinker's tools", "Weaver's tools",
          "Woodcarver's tools", "Disguise kit", "Forgery kit", "Herbalism kit", "Navigator's tools",
          "Poisoner's kit", "Thieves' tools"]
gaming = ["Dice set", "Dragonchess set", "Playing card set", "Three-Dragon Ante set"]
instruments = ['Bagpipes', 'Drum', 'Dulcimer', 'Flute', 'Lute', 'Lyre', 'Horn', 'Pan flute', 'Shawm', 'Viol']
land_transport = ['Camel', 'Donkey/Mule', 'Elephant', 'Horse, draft', 'Horse, riding', 'Mastiff', 'Pony', 'Warhorse']
water_transport = ['Galley', 'Keelboat', 'Longship', 'Rowboat', 'Sailing ship', 'Warship']
standard_languages = ['Common', 'Dwarvish', 'Elvish', 'Giant', 'Gnomish', 'Goblin', 'Halfling', 'Orc']
exotic_languages = ['Abyssal', 'Celestial', 'Draconic', 'Deep Speech', 'Infernal', 'Primordial', 'Sylvan', 'Undercommon']

armor_proficiencies.each {|armor| Proficiency.create({name: armor, label: 'Armor'})}
simple_melee.each {|weapon| Proficiency.create({name: weapon, label: 'Simple melee weapon'})}
simple_ranged.each {|weapon| Proficiency.create({name: weapon, label: 'Simple ranged weapon'})}
martial_melee.each {|weapon| Proficiency.create({name: weapon, label: 'Martial melee weapon'})}
martial_ranged.each {|weapon| Proficiency.create({name: weapon, label: 'Martial ranged weapon'})}
tools.each {|tool| Proficiency.create({name: tool, label: 'Tool'})}
gaming.each {|game| Proficiency.create({name: game, label: 'Gaming set'})}
instruments.each {|instrument| Proficiency.create({name: instrument, label: 'Musical instrument'})}
land_transport.each {|animal| Proficiency.create({name: animal, label: 'Land vehicle'})}
water_transport.each {|ship| Proficiency.create({name: ship, label: 'Water vehicle'})}
standard_languages.each {|lang| Proficiency.create({name: lang, label: 'Standard language'})}
exotic_languages.each {|lang| Proficiency.create({name: lang, label: 'Exotic language'})}

backgrounds = []
