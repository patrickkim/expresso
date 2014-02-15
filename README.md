=======
Expresso
========


### TODOS:
[] config forever to give the app some fight in it. -> When it fails it will try and get back up. 

### Things I might want to add in later.
"walk" of "findit"
"modernizer"
"connect-redis" or "mongoose"
"socket-io"

### Email Usage...
"mime"
"nodemailer"


## Redis DB Schema
users: -> counter (increment with INCR any time you have a new user to be registered)
users:usernames: -> HASH(username -> id, ...)
user.emails: -> HASH(email -> id, ...)
user:<id> -> HASH(u -> <username>, e -> <email>, p -> <hash of password>)