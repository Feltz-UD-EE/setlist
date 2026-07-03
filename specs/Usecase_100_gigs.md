# Gigs

Gigs are also known as bookings or engagements - they are instances of a band playing for
a customer, at a specific place and time, often for money.

## Data structure

### Gigs

The following are the attributes for gigs:

|name|datatype|description|constraints|notes|
+----+--------+-----------+-----------+-----+
|date|date|the date the gig will occur on|not null| |
|band_id|reference|which band the gig is for|not null| |
|client|string|who the gig is for|not null|Can be a person or a business|
|contact|string|the name of the person we communicate with|not null| |
|phone|string|the phone number of the contact| | |
|address|string|the address of the gig| | |
|booked_by|refers to player_id of the user who created the gig|not null| |
|fee|numeric|how much the band is being paid| | |
|venue|string|a description of where the band will be playing| |includes details about indoor/outdoor, electric, etc|
|soundcheck|time|when the band does sound check| | |
|start|time|when the performance starts|must be later than soundcheck; if soundcheck is not null, then this attribute must be not null| |
|end|time|when the performance ends|must be later than start or null| |
|notes|text|freeform notes about the gig| | |
|retrospective|text|freeform notes about how the gig went, critiques, etc| | |

In addition to those, always add the standard Rails id and timestamp columns

I use the concepts of Upcoming Gig and Past Gig frequently; create helper methods for this if
they seem appropriate.

### Gig-setlist join

A gig can have many setlists, a setlist can belong to many gigs.  Create a simple
join table for this relationship.

## UI

### Band pages

On the band show page, add 2 mini tables as follows, above the list of players.

* Past gigs: The most recent 5 gigs before todays date, sorted by date desc, 
showing client and fee as columns; client links to the gig show page
described below. Immediately below that table, add a link to "All Past Gigs",
described below.
* Upcoming gigs: The 5 next gigs on or after todays date, sorted by date asc,
showing client, fee, and start as columns; client links to the gig show page
described below. Immediately below that table, add a link to "All Upcoming Gigs",
described below. Also immediately below that table, add a button labelled 
"Book a Gig" which goes to the gig new page, described below.

### Gig pages

#### New
When creating a new gig (from the Book a Gig button), display the band name and
the name of the player who created the gig at the top of the screen, then form
elements for all the regular attributes except retrospective.  It should also show a drag-and-drop interface
for assigning setlists to the gig; use the same interface structure as that for assigning
songs to a setlist.

#### Edit
The edit page should have the same form elements as the new page; it should display the
band name and the name of the player who created the gig at the top of the screen, it should
then display the created_at and updated_at values.  It should include the same drag-and-drop
interface for assigning setlists to a gig.  The retrospective element is never changed by the
edit page.

#### Show
When showing an existing gig, display the band name and the name of the player who
created it at the top.  Then show a line with created_at and updated_at values.
Then show all other details.  Show the setlists assigned to the gig, if any, with links
to those setlists. If the gig is in the past, show the retrospective attribute,
otherwise hide that attribute. Include an "Edit" button.  Also include a "Rebook" button,
described below in UI actions. If the gig is in the past, show an "Add Restrospective" button,
which goes to the Add Retrospective page.

#### Add Retrospective
Adding a retrospective is a special kind of edit page - the page displays all the normal details
of the gig, and the only form element is retrospective.

#### Past Gigs
The Past Gigs page serves as an index, but only for gigs whose date is before
today's date.  Past gigs should be sorted by date desc.  The table should have 
date, client, fee, and booked_by. The client entry links to the gig show page.

#### Upcoming Gigs
The Upcoming gigs page serves as an index, but only for gigs whose date is today or
a date in the future.  Upcoming gigs should be sorted by date asc.  The table should
have date, client, fee, start, and booked_by. The client entry links to the gig
show page.

### Setlist pages

On the setlist show page, list all of the gigs that a setlist belongs too, with active
links.

## Special controller actions

### Rebook
When the rebook button is pressed on a gig, create a new gig and go to the edit page.
Set the player_id to the player who pressed the button; otherwise copy over all attributes
except date and retrospective.  Show the retrospective notes from the previous gig
at the top of the edit page.

### Email
Whenever an upcoming gig is created or updated, send an email to all players in that band.
On create, the subject of the email should be "New Gig - <date>" and the body of
the email should be all of the show page elements.  On update, the subject of the
email should be "Updated gig info - <date>" and the body of the email should be
all of the show page elements.  Do not send emails for past gigs.

