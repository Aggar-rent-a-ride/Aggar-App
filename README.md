# Aggar App 
Aggar is a vehicle rental platform connecting vehicle owners with customers. Owners can list, edit, and delete their vehicles while managing bookings. Customers search for vehicles by rating, type, brand, or distance, then book securely. The app includes mapping services, notifications, payment processing, and an admin dashboard for platform management, reporting, and user moderation.
// vidoe demo with 3 screens 

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Authentication System](#authentication-system)
   - [Login Page](#login-page)
   - [Registration Pages](#registration-pages)
        - [Screen 1: Personal Information](#screen-1-personal-information)
        - [Screen 2: Credential Information](#screen-2-credential-information)
        - [Screen 3: Location & User Type](#screen-3-location--user-type)
   - [Verification Screen](#verification-screen)
4. [Main Dashboard Pages](#main-dashboard-pages)
   - [Customer Main Page](#customer-main-page)
   - [Renter Main Page](#renter-main-page)
   - [Admin Main Page](#admin-main-page)
5. [Communication System](#communication-system)
   - [Messages Overview Page](#messages-overview-page)
   - [Personal Chat Page](#personal-chat-page)
6. [Notifications System](#notifications-system)
7. [User Profile Management](#user-profile-management)
8. [Settings and Preferences](#settings-and-preferences)
   - [Rental History Page](#rental-history-page)
   - [Payout Details Page](#payout-details-page)
   - [Payment Page](#payment-page)
   - [Personal Info Page](#personal-info-page)
   - [Platform Balance Page](#platform-balance-page)
9. [Vehicle Management](#vehicle-management)
10. [Vehicle Details and Booking](#vehicle-details-and-booking)
    - [Renter Vehicle Details Page](#renter-vehicle-details-page)
    - [Customer Vehicle Details Page](#customer-vehicle-details-page)
     
## Overview
Aggar is a comprehensive vehicle rental marketplace that connects vehicle owners with customers through a seamless online platform. The application provides a complete ecosystem for vehicle sharing with advanced features for all user types.

## Key Features
### For Renters
- **Vehicle Listing Management**: Easily list vehicles on the platform with detailed information and photos
- **Listing Control**: Full editing and deletion capabilities for managing vehicle listings
- **Reservation Management**: Receive and manage booking requests from customers
- **Earnings Tracking**: Monitor rental income and transaction history

### For Customers
- **Advanced Search**: Find vehicles by category, type, brand, or proximity location
- **Location-Based Discovery**: Integrated mapping services for finding nearby vehicles
- **Secure Reservations**: Safe and reliable booking system with instant confirmation
- **Real-Time Communication**: Direct messaging with vehicle owners including file and photo sharing

### Core Platform Features
- **Integrated Mapping**: Location-based search and navigation services
- **Smart Notifications**: Instant updates for bookings, messages, and platform activities
- **Secure Payments**: Protected payment processing for all transactions
- **Instant Messaging**: Built-in communication system between users with multimedia support

### Administrative Dashboard
- **Platform Control**: Comprehensive management of all platform operations
- **Analytics & Reporting**: Detailed reports on usage, revenue, and platform metrics
- **Content Management**: Add new vehicle types, brands, and categories to the system
- **User Monitoring**: Track user activity and platform engagement
- **Moderation Tools**: Enforce platform rules and take disciplinary actions when necessary
- **Safety Assurance**: Maintain a secure and reliable rental experience for all users

## Architecture
```
App Launch → Onboarding → Login/Register → Verification → Main App
```
The authentication flow consists of three primary screens working together to provide a seamless user experience.

## Authentication System
*Complete user authentication and onboarding process*

### Login Page
*User authentication and access control*

### Registration Pages
*Multi-step user registration process*

#### Screen 1: Personal Information
*Collect basic user details and personal information*

#### Screen 2: Credential Information
*Set up login credentials and security information*

#### Screen 3: Location & User Type
*Define user location and select account type (Customer/Renter)*

### Verification Screen
*Account verification and security validation*

## Main Dashboard Pages
*Core application interfaces for different user types*

### Customer Main Page
*Vehicle search, discovery, and booking interface for customers*

### Renter Main Page
*Vehicle management and rental oversight for vehicle owners*

### Admin Main Page
*Platform administration and management dashboard*

## Communication System
*Integrated messaging and communication features*

### Messages Overview Page
*Central hub for all user conversations and communications*

### Personal Chat Page
*Individual conversation interface with multimedia support*

## Notifications System
*Real-time alerts and platform updates*

## User Profile Management
*Personal information and account management*

## Settings and Preferences
*Application configuration and user preferences*

### Rental History Page
*Complete history of all rental transactions and bookings*

### Payout Details Page
*Payment information and earnings management for renters*

### Payment Page
*Payment methods and transaction management for customers*

### Personal Info Page
*User profile information and account details management*

### Platform Balance Page
*Account balance and financial overview*

## Vehicle Management

When you click the add button on the renter main screen, you navigate to the vehicle creation interface. This comprehensive process allows renters to list their vehicles on the platform with detailed information and specifications.

<p align="center">
  <img src="https://github.com/user-attachments/assets/49652d41-f0f6-4e0f-813e-097c7f3251f1" height="500"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 <img src="https://github.com/user-attachments/assets/7979fa12-7640-493c-bd5f-13bd567e4db9" height="500"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/71d9e199-05bb-41ba-9fc8-9ddacc64d7e2" height="500"/>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/32765f75-7e57-4966-ba59-50cb7e01186c" height="500"/>
</p>

#### Vehicle Information Input
- **Data Entry**: Enter comprehensive vehicle details including make, model, year, and specifications
- **Validation System**: Built-in validators prevent empty fields or incorrect information, ensuring data quality
- **Image Upload**: Add multiple photos showcasing the vehicle from different angles
- **Location Setting**: Define the vehicle's pickup location with address details

#### Discount Management
- **Post-Creation Setup**: After vehicle creation, navigate to the discount configuration screen
- **Optional Pricing**: Choose whether to apply discounts to your vehicle listing
- **Multiple Discounts**: Create and manage various discount options and promotional pricing
- **Flexible Pricing**: Adjust rates based on seasonal demand or booking duration

#### Vehicle Modification
- **Edit Capabilities**: Full editing access to modify any vehicle information after creation
- **Real-Time Updates**: Changes are immediately reflected in the platform listings
- **Information Management**: Update specifications, pricing, availability, and descriptions as needed
- **Listing Control**: Maintain current and accurate vehicle informtion throughout the listing lifecycle

#### Vehicle Type & Brand Management

Administrative interface for managing vehicle categories, types, and brands

- **Add New Types**: Create new vehicle type categories through the admin dashboard
- **Edit Existing Types**: Modify vehicle type information and specifications as needed
- **Remove Types**: Delete unused or obsolete vehicle types from the system
- **Add New Brands**: Register new automotive brands in the platform database
- **Edit Brand Information**: Update existing brand details and associated data
- **Remove Brands**: Delete brands that are no longer relevant to the platform

## Vehicle Details and Booking

### Renter Vehicle Details Page

When you click on a vehicle card, it displays the vehicle details page for renters. This interface is similar to the customer's view but presents all information in a unified single-screen layout without section divisions.

<p align="center">
  <img src="https://github.com/user-attachments/assets/7ad23a16-918b-4c0e-9ffc-9514d258c5bc" height="500"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/37975b4d-2d5b-4e33-bf97-693fbd01ff1f" height="500"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/71d9e199-05bb-41ba-9fc8-9ddacc64d7e2" height="500"/>
</p>


#### Features Overview
- **Vehicle Images**: Primary vehicle photos displayed prominently
- **Location Services**: Complete location details with "View on Map" functionality for precise positioning
- **Vehicle Properties**: Comprehensive specifications and feature listings
- **Image Gallery**: Full collection of vehicle photos and visual documentation
- **Rating System**: Overall rating display with customer review comments and total review count
- **Overview Section**: Detailed vehicle description with customer feedback and statistics

#### Pricing Management
- **Pricing Details**: Displays the daily rental rate and any active discounts
- **Discount Control**: Shows current discount percentages and promotional pricing
- **Rate Adjustment**: Ability to modify pricing and discount structures

#### Vehicle Management Actions
- **Menu Options**: Access vehicle management tools through the app bar menu button
- **Delete Function**: Remove vehicle listings with confirmation prompts to ensure intentional deletion
- **Edit Capabilities**: Navigate to the edit screen for comprehensive vehicle information updates
- **Information Updates**: Modify all vehicle details, specifications, and listing information through the dedicated edit interface

### Customer Vehicle Details Page
When you click on a vehicle card, it displays the vehicle details page with three main sections: **About**, **Properties**, and **Reviews**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/2a53c418-2103-40d1-82bb-f35225931221" height="500" alt="Vehicle Details Section 1"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/2da8fc20-fee8-4acd-938b-afcca3ef819a" height="500" alt="Vehicle Details Section 2" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/45dbbc87-9f02-4bcd-ad50-7c922d62fb92" height="500" alt="Vehicle Details Section 3"/>
</p>

#### About Section
- **Renter Information**: Displays the rental partner's profile details with their activity status
- **Messaging**: Provides the ability to message the vehicle owner directly
- **Location Services**: Shows the vehicle's current location with full address and coordinates
- **Map Integration**: Displays the exact location on Google Maps with detailed address information

#### Properties Section
- **Vehicle Capabilities**: Comprehensive overview of the vehicle's features and specifications
- **Image Gallery**: Complete collection of vehicle photos and images
- **Status Indicators**: 
  - Current physical condition of the vehicle
  - Availability status (active/inactive)
  - Stock availability (in stock/out of stock)

#### Reviews Section
- **Rating System**: Displays the overall rating for the vehicle
- **User Comments**: Shows customer reviews and feedback
- **Review Counter**: Displays the total number of reviews received

#### Vehicle Header
- **Vehicle Images**: Primary vehicle photos displayed at the top
- **Basic Information**: Vehicle name, transmission type, and manufacturing year
- **Action Buttons**: 
  - **Book Button**: Located at the bottom of the screen for making reservations
  - **Report Vehicle**: Option to report issues or violations
  - **Save Vehicle**: Ability to save the vehicle to favorites or watchlist
