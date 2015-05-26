layer = (g, p)->[
  "#{g + p}Skin.png"
  "#{g + p}Hair.png"
  "#{g + p}Eyes.png"
  "#{g + p}Expression.png"
  "#{g}Top.png"
]

Person.VailianCrewM = class VailianCrewM extends RandomPerson
  @descriptions: [
    ->"""#{@} doesn't talk about #{his} past much, preferring to look toward the future."""
    ->"""#{@} will talk at great length to anyone who will listen about #{his} childhood. This would be more interesting if #{he} weren't so completely, boringly, normal."""
    ->"""#{@}'s mouth snaps shut the instant anyone tries to ask about where #{he}'s from or why #{he}'s chosen the life of a sailor. Natalie doesn't pry."""
    ->"""#{@} is open, holding no secrets back. #{He}'ll talk readily about #{his} past, but doesn't seem attached to #{his} previous life very strongly."""
    ->"""#{@} is quiet and hardworking, preferring to communicate with actions rather than words."""
    ->"""#{@} seems constantly distracted, busy with #{his} thoughts rather than the world around #{him}. It's either endearing or annoying, depending on the situation."""
    ->"""#{@} tends to scowl more than #{he} smiles - at strangers, anyway. #{He}'s very pleasant once you get past the gruff exterior."""
    ->"""#{@} loves to boast, readily telling anyone who will listen any number of tall tales. Some are more plausible than others. #{he} certainly seems too young to have done <em>all</em> of the things #{he} claims to have done."""
    ->"""#{@} has a childlike air, seemingly innocent and lost, almost as if #{he} wandered into the sailor's life by accident. #{He}'s competent enough, though, no doubt about that."""
    ->"""#{@} is serious and attentive, hopping to obey orders as though #{his} life depended on them - which, in some cases, it does."""
    ->"""#{@} doesn't hesitate to speak #{his} mind, a trait that gets on Natalie's nerves sometimes when #{he} won't shut up, but more often provides valuable feedback."""
    ->"""#{@} jokes constantly, seemingly unable to take anything seriously. Even deadly situations are more likely to get a wisecrack from #{him} than a scowl."""
    ->"""#{@} has a heart of gold, an infinite wellspring of kind smiles and affectionate words."""
  ]
  name: 'VailianCrewM'
  gender: 'm'
  happiness: 40
  text: '#999999'
  @images:
    path: 'src/content/people/Crew/'

    normal: layer 'M', 'Normal'
    happy: layer 'M', 'Happy'
    sad: layer 'M', 'Sad'
    serious: layer 'M', 'Serious'
    angry: layer 'M', 'Angry'
  @colors: [
    {# Skin
      light: false
      ivory: [32, 67, 41]
      tanned: [34, 52, -16]
      golden: [40, 53, -30]
    }
    { # Hair
      fiery: false
      raven: [0, 0, -60]
      ash: [34, 23, -42]
      chestnut: [32, 40, -23]
      copper: [19, 53, -29]
      strawberry: [22, 52, 21]
      blonde: [43, 48, 16]
    }
    { # Eyes
      green: [110, 56, 0]
      blue: [198, 71, 0]
      hazel: [21, 29, 8]
    }
    { # Expression
      none: false
    }
    { # Top
      none: false
    }
  ]

Person.VailianCrewF = class VailianCrewF extends Person.VailianCrewM
  name: 'VailianCrewF'
  gender: 'f'
  @descriptions: Person.VailianCrewM.descriptions
  @images:
    path: 'src/content/people/Crew/'

    normal: layer 'F', 'Normal'
    happy: layer 'F', 'Happy'
    sad: layer 'F', 'Sad'
    serious: layer 'F', 'Serious'
    angry: layer 'F', 'Angry'
  @colors: Person.VailianCrewM.colors

Person.VailianCrewM.names = [
  'HARRY', 'OLIVER', 'JACK', 'ALFIE', 'CHARLIE', 'THOMAS', 'JACOB', 'JAMES', 'JOSHUA', 'WILLIAM'
  'ETHAN', 'GEORGE', 'RILEY', 'DANIEL', 'SAMUEL', 'NOAH', 'OSCAR', 'JOSEPH', 'MOHAMMED', 'MAX'
  'DYLAN', 'MUHAMMAD', 'ALEXANDER', 'ARCHIE', 'BENJAMIN', 'LUCAS', 'LEO', 'HENRY', 'JAKE', 'LOGAN'
  'TYLER', 'JAYDEN', 'ISAAC', 'FINLEY', 'MASON', 'RYAN', 'HARRISON', 'ADAM', 'LEWIS', 'EDWARD', 'LUKE'
  'FREDDIE', 'MATTHEW', 'LIAM', 'ZACHARY', 'CALLUM', 'SEBASTIAN', 'CONNOR', 'JAMIE', 'THEO', 'TOBY'
  'HARVEY', 'MICHAEL', 'NATHAN', 'HARLEY', 'KAI', 'DAVID', 'AARON', 'ALEX', 'CHARLES', 'AIDEN', 'LEON'
  'MOHAMMAD', 'LUCA', 'TOMMY', 'FINLAY', 'JENSON', 'ARTHUR', 'LOUIS', 'RHYS', 'OWEN', 'REUBEN', 'OLLIE'
  'LOUIE', 'GABRIEL', 'BOBBY', 'CAMERON', 'DEXTER', 'BLAKE', 'STANLEY', 'KIAN', 'EVAN', 'JUDE', 'FRANKIE'
  'ELLIOT', 'HAYDEN', 'ASHTON', 'JOEL', 'CALEB', 'BAILEY', 'ELIJAH', 'TAYLOR', 'ROBERT', 'KAYDEN', 'KYLE'
  'FREDERICK', 'BEN', 'REECE', 'JACKSON', 'JOHN', 'AIDAN', 'SETH', 'ELLIS', 'COREY', 'BRADLEY', 'BILLY'
  'ELLIOTT', 'SONNY', 'TOBIAS', 'RORY', 'CHRISTOPHER', 'SAM', 'MUHAMMED', 'IBRAHIM', 'CODY', 'AUSTIN'
  'AYAAN', 'BRANDON', 'NATHANIEL', 'DOMINIC', 'PATRICK', 'OLLY', 'ZAC', 'THEODORE', 'KAIDEN', 'JAY'
  'MORGAN', 'YUSUF', 'KIERAN', 'ALBERT', 'FELIX', 'MAXWELL', 'TRISTAN', 'JAKUB', 'ROWAN', 'FINN', 'ZAIN'
  'JASPER', 'HUGO', 'JOE', 'ANDREW', 'RONNIE', 'EWAN', 'ALI', 'FILIP', 'ZACK', 'JONATHAN', 'NICHOLAS'
  'DECLAN', 'LEVI', 'COLE', 'MOHAMED', 'ANTHONY', 'ZAK', 'PETER', 'TEDDY', 'MARLEY', 'ALFRED', 'JASON'
  'RIO', 'LAYTON', 'ABDULLAH', 'FLYNN', 'ELI', 'SYED', 'XAVIER', 'MILO', 'JONAH', 'ZACH', 'MARCUS'
  'JAIDEN', 'MAXIMILIAN', 'ROMAN', 'KACPER', 'AHMED', 'RUBEN', 'MCKENZIE', 'LENNON', 'REGGIE', 'SEAN'
  'OSKAR', 'DANNY', 'SPENCER', 'JESSE', 'MILES', 'JENSEN', 'BEAU', 'HAMZA', 'LEIGHTON', 'ABDUL', 'ROHAN'
  'JADEN', 'ROCCO', 'CARTER', 'FRASER', 'KEVIN', 'TOM', 'MARK', 'ALAN', 'JAXON', 'ASHLEY', 'JOSH', 'VINCENT'
  'CHRISTIAN', 'PRESTON', 'EMMANUEL', 'SHAY', 'ASTON', 'HASSAN', 'LUKAS', 'TRAVIS', 'MYLES', 'RYLEY'
  'ADRIAN', 'BRODY', 'LEONARDO', 'JORDAN', 'ALBIE', 'MAXIMUS', 'FLETCHER', 'RAYYAN', 'OAKLEY', 'OMAR'
  'DOMINIK', 'MALACHI', 'MUSA', 'KENZIE', 'BARNABY', 'MUSTAFA', 'RALPH', 'VINNIE', 'ARYAN', 'ZANE'
  'EUAN', 'CAYDEN', 'CHASE', 'RICHARD', 'TED', 'RUFUS', 'RAPHAEL', 'FRANK', 'ISMAIL', 'SCOTT', 'JUSTIN'
  'MARTIN', 'ELIAS', 'JUNIOR', 'CAIDEN', 'CIAN', 'KANE', 'ERIC', 'RAYAN', 'ISAIAH', 'ZAKARIYA', 'STEPHEN'
  'VICTOR', 'FREDDY', 'YAHYA', 'RYLEE', 'SIDNEY', 'UMAR', 'KADEN', 'CASEY', 'PAUL', 'LENNY', 'MITCHELL'
  'KYE', 'PATRYK', 'MATEUSZ', 'WILL', 'ARJUN', 'LINCOLN', 'CONOR', 'JOEY', 'BROOKLYN', 'SZYMON', 'JAI'
  'RAFAEL', 'MICAH', 'SHANE', 'ARLO', 'DAWID', 'LEE', 'BENTLEY', 'COOPER', 'MARCEL', 'RUPERT', 'ISA'
  'CIARAN', 'TOMAS', 'FRANCIS', 'TROY', 'JULIAN', 'JIMMY', 'FABIAN', 'FINNLEY', 'SAMI', 'MICHAL'
  'NIALL', 'ROBIN', 'STEVEN', 'TIMOTHY', 'JAN', 'NICOLAS', 'BILAL', 'DILLON', 'MARSHALL', 'SIMON'
  'WILFRED', 'BRODIE', 'CADEN', 'MACKENZIE', 'JOSIAH', 'RYLAN', 'COHEN', 'ZAYN', 'AHMAD', 'JEREMIAH'
  'SOLOMON', 'BRAYDEN', 'AMIR', 'HECTOR', 'EESA', 'IVAN', 'KALEB', 'OLIVIER', 'SHAUN', 'CURTIS'
  'GETHIN', 'DEVON', 'HARRIS', 'HASAN', 'LUKA', 'WARREN', 'ZACHARIAH', 'DAMIAN', 'JARED', 'ALEKSANDER'
]
Person.VailianCrewF.names = [
  'AMELIA', 'OLIVIA', 'LILY', 'JESSICA', 'EMILY', 'SOPHIE', 'RUBY', 'GRACE', 'AVA', 'ISABELLA', 'EVIE'
  'CHLOE', 'MIA', 'POPPY', 'ISLA', 'ELLA', 'ISABELLE', 'SOPHIA', 'FREYA', 'DAISY', 'CHARLOTTE', 'MAISIE'
  'LUCY', 'PHOEBE', 'SCARLETT', 'HOLLY', 'LILLY', 'ELLIE', 'MEGAN', 'LAYLA', 'LOLA', 'IMOGEN', 'EVA'
  'SUMMER', 'MILLIE', 'SIENNA', 'ALICE', 'ABIGAIL', 'ERIN', 'LACEY', 'HANNAH', 'JASMINE', 'FLORENCE'
  'ELIZABETH', 'LEXI', 'MOLLY', 'SOFIA', 'MATILDA', 'EMMA', 'BROOKE', 'AMY', 'AMBER', 'GRACIE', 'AMELIE'
  'ROSIE', 'LEAH', 'KATIE', 'MAYA', 'ELEANOR', 'GEORGIA', 'EMILIA', 'ELIZA', 'FAITH', 'BETHANY', 'EVELYN'
  'ISABEL', 'ANNA', 'HOLLIE', 'BELLA', 'PAIGE', 'HARRIET', 'ESME', 'ZARA', 'LEXIE', 'WILLOW', 'ROSE', 'MADISON'
  'JULIA', 'ANNABELLE', 'ISOBEL', 'NIAMH', 'MADDISON', 'MARTHA', 'SKYE', 'LAUREN', 'CAITLIN', 'ELSIE', 'KEIRA'
  'REBECCA', 'SARAH', 'HEIDI', 'ZOE', 'MARIA', 'MARYAM', 'AISHA', 'TIA', 'NICOLE', 'KAYLA', 'FRANCESCA', 'LYDIA'
  'ALEXIS', 'MAISY', 'TILLY', 'AIMEE', 'MYA', 'LIBBY', 'ALEXANDRA', 'VICTORIA', 'SARA', 'DARCY', 'GABRIELLA'
  'LILLIE', 'MOLLIE', 'VIOLET', 'ALISHA', 'AALIYAH', 'ELOISE', 'NEVAEH', 'LARA', 'ANNABEL', 'LOIS', 'FATIMA'
  'ANGEL', 'LAILA', 'ALICIA', 'BEATRICE', 'SEREN', 'MAJA', 'EVE', 'INDIA', 'DARCEY', 'DARCIE', 'NATALIA', 'LAURA'
  'NANCY', 'LEILA', 'MILEY', 'LOTTIE', 'ANYA', 'NAOMI', 'ZAINAB', 'FAYE', 'ELISE', 'ANNIE', 'SAVANNAH', 'NEVE'
  'IRIS', 'ESTHER', 'MADELEINE', 'EDEN', 'LENA', 'ALEXA', 'LYLA', 'ZAHRA', 'ORLA', 'FRANKIE', 'GEORGINA', 'ABBIE'
  'SADIE', 'ALYSSA', 'COURTNEY', 'CONNIE', 'MACEY', 'ALEENA', 'LUCIE', 'MACIE', 'HOPE', 'IVY', 'KATHERINE'
  'ALEXIA', 'ELENA', 'SCARLET', 'ZUZANNA', 'ROBYN', 'JENNIFER', 'JEMIMA', 'TABITHA', 'FELICITY', 'AUTUMN'
  'EBONY', 'AMIRA', 'ELSA', 'FFION', 'CERYS', 'LUCIA', 'KARA', 'MARIAM', 'LACIE', 'AMINA'
  'RACHEL', 'KAITLYN', 'BETSY', 'YASMIN', 'NINA', 'TEGAN', 'MELISSA', 'NADIA', 'KITTY', 'HONEY', 'CAITLYN'
  'CASEY', 'AYESHA', 'PIPPA', 'EDITH', 'SAFA', 'ARABELLA', 'TAYLOR', 'HANNA', 'MACY', 'CLARA'
  'DEMI', 'TALLULAH', 'JESSIE', 'MAGGIE', 'BONNIE', 'CARA', 'MAIA', 'NATALIE', 'KIERA', 'MICHELLE'
  'ALANA', 'KHADIJA', 'LEYLA', 'KACEY', 'TIANA', 'EMELIA', 'NATASHA', 'MILLY', 'SAMANTHA', 'CATHERINE'
  'KHADIJAH', 'THEA', 'LANA', 'CARYS', 'DESTINY', 'EDIE', 'HAFSA', 'JOSIE', 'SYEDA'
  'GEORGIE', 'ROSA', 'ALESHA', 'GABRIELA', 'MAISEY', 'MARY', 'OLIWIA', 'ANAYA', 'VANESSA', 'KELSEY', 'AMAYA'
  'EMMIE', 'PENELOPE', 'ELLEN', 'SASHA', 'ELODIE', 'JOSEPHINE', 'MILA', 'IQRA', 'KAYLEIGH'
  'DANIELLE', 'ALIYAH', 'APRIL', 'KATE', 'AYLA', 'BELLE', 'GABRIELLE', 'POLLY', 'TALIA', 'BEAU', 'MELODY'
  'TIFFANY', 'BETHAN', 'LILIANA', 'AMINAH', 'INAAYA', 'SKYLA', 'TIANNA', 'IMAAN', 'KYRA'
  'ZOYA', 'LOUISE', 'CONSTANCE', 'EVANGELINE', 'NICOLA', 'PHILIPPA', 'ZOFIA', 'CIARA', 'CLAUDIA', 'MORGAN'
  'AOIFE', 'IZABELLA', 'LILIA', 'RIA', 'PEYTON', 'STEPHANIE', 'BEATRIX', 'HANA', 'JADE', 'KYLA', 'NIA', 'STELLA'
  'SYDNEY', 'INAYA', 'MADELINE', 'CHARLIE', 'LILA', 'NOOR', 'BETH', 'ROXANNE', 'NIKOLA', 'AMIRAH', 'DANIELLA', 'LAIBA'
  'KATELYN', 'KATY', 'HALLE', 'ISOBELLE', 'KEELEY', 'MACI', 'LYRA', 'ALINA', 'DELILAH', 'HELENA', 'LOUISA', 'ARIANA'
  'ESMEE', 'HALLIE', 'SANA', 'CHELSEA', 'RIHANNA', 'ALICJA', 'SAPPHIRE', 'LIVIA', 'TEAGAN', 'ASHLEIGH', 'CRYSTAL'
  'EMILIE', 'MAIZIE', 'OLIVE', 'ALEEZA', 'CHARLEY', 'INAYAH', 'SHANNON', 'WIKTORIA', 'ELIANA', 'SAFFRON', 'FATIMAH'
  'ANNABELLA', 'HALIMA', 'KACIE', 'KIARA', 'ALIZA', 'JASMIN', 'MABEL', 'ALEKSANDRA', 'HAZEL', 'JOANNA'
  'KHLOE', 'MADDIE', 'SERENA', 'HARMONY', 'ZAYNAB', 'HAYLEY', 'SIAN', 'AMARA', 'ELA', 'ERICA', 'IONA'
  'ANGELINA', 'LUNA', 'PEARL', 'AAMINAH', 'JENNA', 'LIBERTY', 'ANASTASIA', 'TANISHA', 'TAYLA'
  'ADA', 'AMEERA', 'PRINCESS', 'SIMRAN', 'DIYA', 'VERITY', 'HERMIONE', 'MYLA', 'SASKIA', 'ELISHA', 'NELL'
  'MALAIKA', 'MIRIAM', 'PENNY', 'ROXY', 'ESMAE', 'DIANA', 'AIZA', 'ANA', 'AURORA', 'SALMA'
  'SKY', 'PRIYA', 'HALEEMA', 'INDIE', 'FLORA', 'OPHELIA', 'AURELIA', 'ISHA', 'KIRA', 'MAY'
  'RUTH', 'ABBY', 'COCO', 'KAITLIN', 'HAFSAH', 'TILLIE', 'LILLIAN', 'ARIANNA', 'BRIANNA', 'CARMEN'
  'ALISHBA', 'MICHAELA', 'ANNALISE', 'AYSHA', 'LEONA', 'NIKITA', 'NYLA', 'PIXIE', 'RIYA', 'FLEUR'
  'POPPIE', 'AMNA', 'SAFAA', 'JORJA', 'RUBIE', 'SAFIYA', 'KIMBERLEY', 'CARLA', 'CLEMENTINE', 'FARRAH'
  'HATTIE', 'HONOR', 'MARWA', 'SABRINA', 'TAMARA', 'ZAINA', 'ADELE', 'ALYSSIA', 'CALLIE', 'CORA', 'ELISSA', 'LILI'
  'BIANCA', 'ISRA', 'MARLEY', 'TARA', 'ANAIS', 'AUDREY', 'CASSIE', 'JODIE', 'KARINA', 'PARIS', 'ELIN', 'ESHAL'
  'JULIETTE', 'RENEE', 'TRINITY', 'AQSA', 'GEMMA', 'IMAN', 'RHEA', 'SHREYA', 'SIENA', 'AYA'
  'CLEO', 'MAE', 'ANTONIA', 'ELLE', 'ISOBELLA', 'YASMINE', 'AMIE', 'BETTY', 'CARLY'
  'TULISA', 'AMANDA', 'MIYA', 'TAYA', 'ALESSIA', 'BAILEY', 'CHRISTINA', 'DEBORAH', 'KACI', 'LIA', 'LILAH'
  'ALAYNA', 'ELISA', 'FARAH', 'GENEVIEVE'
]
