# MatChat

In the spirit of [everyone in the world](https://github.com/github/hubot/network) 
reinventing [Hubot](http://hubot.github.com), I've decided to jump on the 
[bandwagon](https://github.com/teddziuba/hubot). But much like Ted,
I favour the simplest thing that works. Which in this case means not using
Campfire. I'll check my misgivings about Campfire at the door, and simply state
that I already use a networked communication system all day every day: Jabber. 

Up until today, I've used the most excellent
[Partychat](http://partychapp.appspot.com/) service to make this happen. It's
such a well built tool, and works so transparently that I've always wondered
why more people didn't use it. However, it isn't without its quirks. One of
the most annoying of those was that the command based nature of inviting and
joining rooms makes it hard to add bot functionality to it. Thus, MatChat was
born.

MatChat is the simplest thing that can pass as a multi-user chatroom. 

## Installing it

This part is easy. 

1. Create a Jabber account somewhere for this room to use. This can be as
   simple as creating a new gmail user.

2. Clone this repo

        git clone git@github.com/mtrudel/matchat

3. Create a heroku app to host it in

        heroku apps:create --stack cedar

4. Specify the credentials of your user from step 1

        heroku config:add \
          JABBER_USERNAME=mychatroom@gmail.com \
          JABBER_PASSWORD=sekrit\
          JABBER_HOSTNAME=talk.google.com \
          BOOTSTRAP_BUDDIES="you@yourself.com someoneelse@them.com"

    If you're using a gmail account, `JABBER_HOSTNAME` will be
    `talk.google.com`. Otherwise it will be the name of your Jabber host
    (MatChat isn't smart enough to walk DNS SRV records, so you actually have to
    specify this if it differs from the domain part of the username).

    The purpose of `BOOTSTRAP_BUDDIES` is to define the set of people
    able to connect to the chatroom. Only people listed here will be able to add the
    chatroom account to their roster and communicate through it. The list
    should be a set of Jabber IDs, space separated.

5. Deploy your app, scale up your bot worker, and scale down your web worker
   (to stay within Heroku's free tier)

       heroku ps:scale web=0 bot=1

6. Anyone listed in `BOOTSTRAP_BUDDIES` will be allowed to connect to the
   chatroom simply by adding the Jabber user you created in step 1 to their
   roster. Messages sent there will be forwarded to all other members of the
   chatroom.

## Using it

In addition to its basic functionality as a chatroom, MatChat has a number of
commands to make life more fun.

- `/snooze <duration>`: This will temporarily stop delivery of messages to you
  until the specified amount of time has elapsed, or until you write something
  to the chatroom. Duration can be specified in plain English -- something like
  `/snooze 1 hour` or `/snooze 10m` should work fine.

- `/nick <nickname>`: Changes your nickname to be the specified name. Does not
  check for conflicts within the chatroom, and currently doesn't remember you
  nickname across server restarts.

## Extending it

In progress -- fork and add your own plugin
