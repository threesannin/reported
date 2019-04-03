Reported - README
===

# Reported

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Report issues dealing with city/state infustructure damage/disturbances which includes Graffiti, Litter, Roadway(Potholes, Roadkill), Landscaping, etc. This app uses current geo-location to report issues along with a short easy to fill survey. This information will be sent to the appropriate city/state reporting outlet (email, online form, etc). 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Reporting
- **Mobile:** iOS
- **Story:** 
- **Market:** Anyone
- **Habit:** 
- **Scope:** California

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can register a new account
* User can login
* User can submit issues 
* User can view submissions
* User can upvote/downvote issues
* User can view their profile recent reports

**Optional Nice-to-have Stories**

* User can report issues outside of California
* User can view city information (email, phone, people to contact)
* Users can add optional photos to issue
* User can received notification of local issues

### 2. Screen Archetypes

* Login
    * User can login
* Register
    * User can register a new account
* Map
    * User can submit issues
* Submission form
    * User can submit issues
* View Reports
    * User can view submissions
    * User can upvote/downvote issues
* Profile
* ...

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Map
* Profile
* Alerts

**Flow Navigation** (Screen to Screen)

* Login 
    * Map
* Register
    * Map
* Map
   * Submission form
   * Alerts page
* Profile
   * Profile page
   * Submission history
* Alerts
    * Alerts page

## Wireframes
<img src="https://i.imgur.com/yrR4CNq.png" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
|Property|Type|Description|
|---|---|---|
|category|string|type of issue to be reported|
|dirOfTravel|string|direction defined by N,S,E,W|
|modeOfTrans|string|type of transportation like car, boat, walking, ect  |
|crossStreet|string|nearest intersection to issue|
|date|string|date issue was created|
|time|string|time issue was created|
|image|File|image related to issue|
|latitude|string|latitude coordinate of issue|
|longitude|string|longitude coordinate of issue|
|description|string|description of issue|
|receiveResponse|boolean|whether or not follow up response is needed|
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
