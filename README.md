![Build Status](https://github.com/tarunsubash/SKEssentialFeed/actions/workflows/CI.yml/badge.svg)

# SKEssentialFeed
A repository to practice concepts learned during Lead Developer Essentials Program

# What's in this Repo?
It is a repo created for practicing iOS concepts. This repo aims at creating an app, that allows users to fetch and view their image feed.

## Image Feed Laod Feature Specifications
### Persona 1: An Online Customer

### User Story
```
As an Online Customer, (Given)
When I open the FeedLoader App, (When)
I want the app to load my latest image feed by itself, (Then)
so I can enjoy latest Feed.(Value)
```
### Acceptance Criteria

```
 Given the customer has connectivity
 When the customer requests to see their feed
 Then the app should display the latest feed from remote
  And replace the cache with the new feed
```

![Fig: RemoteFeedLoader](https://github.com/tarunsubash/SKEssentialFeed/assets/9212548/f6e5ee90-ff08-401b-a94a-1126ffb7eb2b)

# Use Case
### Load Feed Data From Remote

### Data
- Feed URL

### Happy Path:
1. Fetch Image Feed using above Data
2. App Downloads Data from URL
3. Validate the fetched Data
4. Present the valid Feed Data

### Sad Path - Invalid Data
+ Deliver Invalid Data Error
  
### Sad Path - No Connectivity
+ Deliver NoConnectivity Error
