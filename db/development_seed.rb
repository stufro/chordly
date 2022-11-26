User.destroy_all
ChordSheet.destroy_all
SetList.destroy_all

user1 = FactoryBot.create :user, email: "user@chordly.co.uk"
user2 = FactoryBot.create :user, email: "beta@chordly.co.uk"
user3 = FactoryBot.create :user, email: "admin@chordly.co.uk", admin: true
user4 = FactoryBot.create :user, email: "unconfirmed@chordly.co.uk"
user1.confirm
user2.confirm
user3.confirm

chord_sheet1 = FactoryBot.create :chord_sheet, name: "Yellow - Coldplay", user: user1, content_string: "[Intro]
G D C G

[Verse 1]
G
Look at the stars
                       D
Look how they shine for you
                      Cmaj7
And everything you do

Yeah, they were all yellow
G
I came along
                  D
I wrote a song for you
                          Cmaj7
And all the things you do

And it was called 'Yellow.'
G                D
So then I took my turn
                            Cmaj7
Oh what a thing to have done
                       G Gsus4
And it was all yellow

[Chorus 1]
Cmaj7
Your skin
Em7      D
Oh yeah, your skin and bones
Cmaj7  Em7          D
Turn into something beautiful
Cmaj7     Em7        D          Cmaj7
You know, you know I love you so

You know I love you so

[Instrumental]
G   D   C   G Gsus4

[Verse 2]
G
I swam across
                   D
I jumped across for you
                      Cmaj7
Oh, what a thing to do

'Cause you were all yellow
G
I drew a line
                 D
I drew a line for you
                      Cmaj7
Oh, what a thing to do
                      G Gsus4
And it was all yellow

[Chorus 2]
C
Your skin
Em7           D
Oh yeah, your skin and bones
Cmaj7  Em7          D
Turn into something beautiful
Cmaj7
And you know
Em7       D            Cmaj7
For you I bleed myself dry

For you I bleed myself dry"

chord_sheet2 = FactoryBot.create :chord_sheet, name: "Hotel California", user: user1, content_string: "Capo 2

[Intro]
Am   E7   G   D   F   C   Dm   E7

[Verse]
Am                         E7
  On a dark desert highway, cool wind in my hair
G                      D
  Warm smell of colitas rising up through the air
F                          C
  Up ahead in the distance, I saw a shimmering light
Dm
   My head grew heavy and my sight grew dim
E7
  I had to stop for the night

Am                               E7
  There she stood in the doorway; I heard the mission bell
G
  And I was thinking to myself
              D
This could be heaven or this could be hell
F                          C
  Then she lit up a candle, and she showed me the way
Dm
   There were voices down the corridor,
E7
  I thought I heard them say...

[Chorus]
F                          C
  Welcome to the Hotel California.
       E7                                          Am
Such a lovely place, (such a lovely place), such a lovely face
F                               C
Plenty of room at the Hotel California
    Dm                                       E7
Any time of year, (any time of year) You can find it here

[Verse]
Am                            E7
 Her mind is Tiffany-twisted, She got the Mercedes bends
G                                    D
 She got a lot of pretty pretty boys   she calls friends
F                                   C
  How they danced in the courtyard, sweet summer sweat
Dm                       E7
  Some dance to remember, some dance to forget

Am                           E7
  So I called up the captain; Please bring me my wine (he said)
G                                     D
 We haven't had that spirit here since 1969
F                                         C
  and still those voices are calling from far away
Dm
   Wake you up in the middle of the night
E7
  Just to hear them say...

[Chorus]
F                         C
 Welcome to the Hotel California.
       E7                                          Am
Such a lovely place, (such a lovely place), such a lovely face
        F                             C
They're livin' it up at the Hotel California
       Dm                                               E7
What a nice surprise, (what a nice surprise) Bring your alibis

[Verse]
Am                        E7
   Mirrors on the ceiling; the pink champagne on ice (and she said)
G                                D
  We are all just prisoners here, of our own device
F                              C
  and in the master's chambers, they gathered for the feast
Dm
 They stab it with their steely knives but they
E7
just can't kill the beast

Am                             E7
   Last thing I remember, I was running for the door
G                                       D
  I had to find the passage back to the place I was before
F                                   C
  'Relax' said the night man; we are programmed to receive
Dm
  You can check out any time you like
E7
 But you can never leave...

[Outro Solo]
Am   E7   G   D   F   C   Dm   E7

[Harmonies]
Am   E7   G   D   F   C   Dm   E7
(fade out)"

chord_sheet3 = FactoryBot.create :chord_sheet, name: "Perfect - Ed Sheeran", user: user1, content_string: "[Intro]
G

[Verse 1]
          G        Em
I found a love for me
              C                            D
Darling, just dive right in, and follow my lead
                G          Em
Well, I found a girl beautiful and sweet
        C                                     D
I never knew you were the someone waiting for me

[Pre-Chorus]
                                G
Cause we were just kids when we fell in love
            Em                      C                G  D
Not knowing what it was, I will not give you up this ti-ime
             G                           Em
Darling just kiss me slow, your heart is all I own
            C                     D
And in your eyes you're holding mine

[Chorus]
      Em   C             G          D              Em
Baby, I'm dancing in the dark, with you between my arms
C                G     D                Em
Barefoot on the grass, listening to our favourite song
          C                G                 D              Em
When you said you looked a mess, I whispered underneath my breath
         C                G        D             G
But you heard it, darling you look perfect tonight

| G D/F# Em D | C  D  |

[Verse 2]
                G                    Em
Well, I found a woman, stronger than anyone I know
              C                                          D
She shares my dreams, I hope that someday I'll share her home
           G             Em
I found a love, to carry more than just my secrets
         C                              D
To carry love, to carry children of our own

[Pre-Chorus]
                             G                     Em
We are still kids, but we're so in love, fighting against all odds
             C               G  D
I know we'll be alright this ti-ime
             G                              Em
Darling just hold my hand, be my girl, I'll be your man
         C               D
I see my future in your eyes

[Chorus]
      Em   C              G         D              Em
Baby, I'm dancing in the dark, with you between my arms
C                G     D                Em
Barefoot on the grass, listening to our favourite song
        C                G                D
When I saw you in that dress, looking so beautiful
  Em       C                  G        D          [ G ]
I don't deserve this, darling you look perfect tonight

[Interlude]
| G  | % | Em | % |
| C  | % | D  | % |

[Chorus]
      Em   C              G         D              Em
Baby, I'm dancing in the dark, with you between my arms
C                G     D                Em
Barefoot on the grass, listening to our favourite song
        C              G               D             Em
I have faith in what I see, now I know I have met an angel
    C          G         D
In person, and she looks perfect

[Outro]
  G/B     C           Dsus4    D        [ G ]
I don't deserve this, you look perfect tonight

| G D/F# Em D | C  D  | G"

chord_sheet4 = FactoryBot.create :chord_sheet, name: "Talking to the moon", user: user2, content_string: "[Verse 1]

C
  I know you're somewhere out there
E7
Somewhere far away
  Am           G
I want you back
  F
I want you back

C
  My neighbors think I'm crazy
    E7
But they don't understand
       Am        G
You're all I had
       F
You're all I had


[Pre-Chorus]

Dm                      G
   At night when the stars
               Dm
light up my room
            G
I sit by myself


[Chorus]

               F G Am
Talking to the moon
              F G Am
Tryna get to you
   F                    G         C       G/B   Am
In hopes you're on the other side talking to me too
   G      F              G
Or am I a fool who sits alone
                Am  G
Talking to the moon
     D
Ohhhhhhhhhhhhhhhhhhhhhh


[Verse 2]

C
  I'm feelin' like I'm famous
    E7
The talk of the town
         Am           G
They say I've gone mad
      F
Yeah, I've gone mad

C
  But they don't know what I know
      E7
Cause when the sun goes down
          Am           G
Someone's talkin' back
              F
Yeah, they're talkin' back, ohhh


[Pre-Chorus]

Dm                      G
   At night when the stars
               Dm
light up my room
            G
I sit by myself


[Chorus]

               F G Am
Talking to the moon
              F G Am
Tryna get to you
   F                    G         C       G/B   Am
In hopes you're on the other side talking to me too
   G      F              G
Or am I a fool who sits alone

Talking to the moon


[Interlude]

Dm      C      Dm
  Ahh... ahh... ahh...
G
Do you ever hear me calling?
Dm      C      Dm
  (Ahh... ahh... ahh...)


[Chorus]

      G                              F G Am
Cause every night I'm talking to the moon
                       F G Am
Still tryna to get to you
   F                    G         C       G/B   Am
In hopes you're on the other side talking to me too
   G      F              G                     Am   G    D
Or am I a fool who sits alone talking to the moon?     Ohoooo..."

FactoryBot.create :set_list, chord_sheets: [chord_sheet1, chord_sheet3], user: user1
