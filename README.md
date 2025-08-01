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
        - [Screen 3: Location & User Type Selection](#screen-3-location--user-type-selection)
   - [Verification Screen](#verification-screen)
4. [Main Dashboard Pages](#main-dashboard-pages)
   - [Customer Main Page](#customer-main-page)
   - [Renter Main Page](#renter-main-page)
   - [Admin Main Page](#admin-main-page)
5. [Communication System](#communication-system)
   - [Messages Overview Page](#messages-overview-page)
   - [Personal Chat Page](#personal-chat-page)
6. [Notifications System](#notifications-system)
7. [Profile Managment]
8. [Profile and Settings Page](#profile-and-settings-page)
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

### Onboarding Flow
The application begins with an intelligent onboarding system that determines the user's path based on their installation status and account history:

- **First-Time Installation**: New users are directed to the login page to begin the authentication process
- **Existing Account Holders**: Users with valid credentials can log in directly and proceed to their respective main screens
- **Account Type Routing**: 
  - **Renters** are directed to the Renter Main Screen upon successful login
  - **Customers** are directed to the Customer Main Screen upon successful login
- **New User Registration**: Users without accounts are guided through the comprehensive registration process

### Login Page

The login page serves as the primary entry point for existing users, providing secure access to their accounts with credential validation and account activation status verification.

### Registration Pages

The registration process consists of three sequential screens, each with built-in validation to ensure data integrity and completeness before proceeding to the next step.

#### Screen 1: Personal Information

This initial registration screen captures essential personal information:
- **Username**: Unique identifier for the user account
- **Full Name**: User's complete legal name
- **Date of Birth**: Age verification and account personalization
- **Validation Requirements**: All fields must be completed and validated before proceeding to the next screen

#### Screen 2: Credential Information

The credential setup screen establishes account security:
- **Email Address**: Primary contact and login identifier
- **Password**: Secure password meeting platform requirements
- **Password Confirmation**: Verification field to ensure password accuracy
- **Validation Process**: Email format validation and password matching confirmation required before advancing

#### Screen 3: Location & User Type Selection

The final registration screen completes the account setup:
- **Location Services**: GPS-based location detection or manual address entry
- **Address Information**: Complete address details for service area determination
- **User Type Selection**: Choose between Customer or Renter account types
- **Terms and Conditions**: Mandatory acceptance of platform terms and policies
- **Final Validation**: All fields must be completed and terms accepted before proceeding to verification

### Verification Screen

The verification system ensures account security and email validity:
- **Email Code Delivery**: Verification code sent to the registered email address
- **Code Input**: Six-digit verification code entry interface
- **Resend Functionality**: Option to resend verification code if not received
- **Account Activation**: Upon successful verification, users return to the login page to access their activated account
- **Login Redirect**: Verified users can now log in and access their appropriate main screen based on their selected user type

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

The Aggar platform features a comprehensive real-time notification system that keeps all users informed of important activities and transactions. The system provides instant updates with read/unread status tracking to ensure users never miss critical information.

<p align="center">
  <img src="https://github.com/user-attachments/assets/df4dcc59-ceee-46f5-8be4-6b9f4fb5407e" height="400"/>
  &nbsp;&nbsp;&nbsp; 
   <img src="https://github.com/user-attachments/assets/0209f2b0-3bb8-44aa-9119-c4f43ceac82a" height="400"/>
     &nbsp;&nbsp;&nbsp;
 <img src="https://github.com/user-attachments/assets/a2db198a-c49c-44ab-92a1-070a1b5ee43c" height="400"/>

</p>

### Booking Process Notifications

#### Customer Booking Request
When a customer selects a vehicle and chooses their preferred booking dates and times, the system automatically sends a real-time notification to the vehicle owner. This notification includes:
- Customer booking request details
- Selected rental dates and duration
- Pickup and return time preferences
- Customer profile information

#### Renter Response Notifications
Vehicle owners receive booking requests and can respond with two actions:


**Acceptance Process:**
- When a renter accepts a booking request, the customer receives an instant notification confirming the approval
- The notification includes booking confirmation details and next steps for payment processing
- The system updates the booking status to "Approved - Pending Payment"

**Decline Process:**
- If a renter declines the booking request, the customer receives immediate notification of the rejection
- The notification may include alternative suggestions or reasons for decline
- The system automatically releases the booking hold and updates availability

#### Payment Confirmation Notifications
Once a booking is approved and the customer proceeds with payment:
- Payment processing notifications are sent in real-time to confirm transaction status
- Successful payment triggers confirmation notifications to both customer and renter
- Final booking confirmation includes rental details, pickup instructions, and contact information

### Notification Features
- **Read Status Tracking**: All notifications are marked as read/unread for better user experience
- **Real-Time Delivery**: Instant notification delivery ensures immediate communication
- **Comprehensive Coverage**: Notifications cover all stages of the booking and rental process
- **Status Updates**: Continuous updates throughout the entire rental journey from request to completion

## Profile and Settings Page

The Profile and Settings page offers comprehensive account management through multiple organized sections:

### Personal Information Management
- **Personal Info**: Complete profile information that users can view and edit as needed
- **Account Details**: Manage personal data, contact information, and profile preferences

<p align="center">
  <img src="https://github.com/user-attachments/assets/1f042c69-2f62-4480-b932-09884186d403" height="400"/>
  &nbsp;&nbsp;&nbsp;
 <img src="https://github.com/user-attachments/assets/c74a956d-b3fc-49b8-b810-5f5e9da2a03a" height="400"/>

</p>

### Financial Management
The financial section varies based on user type:

<p align="center">
  <img src="https://github.com/user-attachments/assets/299bc44b-1121-4110-9381-a7704928c3e8" height="400"/>
  &nbsp;&nbsp;&nbsp;
 <img src="https://github.com/user-attachments/assets/9855c46b-d482-4caa-b87c-236dd1b6b50f" height="400"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/30b5d2ec-7e78-456b-953e-05b66f5ee82d" height="400"/>
   &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/d8f65136-b63b-493c-928c-e1ebdff69e85" height="400"/>
</p>

#### For Renters
- **Payment Setup**: Activate or create Stripe account integration for secure payment processing
- **Account Status**: If a Stripe account already exists, a confirmation notification is displayed
- **Payout Details**: Access detailed payout information including incoming earnings and transaction details
- **Rental History**: Complete history of all rental transactions with advanced filtering options

#### For Customers  
- **Payment Methods**: Manage payment options and billing information
- **Rental History**: Comprehensive booking history with filtering capabilities and detailed transaction views

#### For Admins  
- **Platform Balance**: Monitoring the application stripe account

### Transaction History
- **Rental History Access**: Click on rental history to view all past transactions
- **Advanced Filtering**: Sort and filter rental history by various criteria
- **Detailed Views**: Navigate to specific rental details for comprehensive transaction information

### Application Preferences
- **Settings & Preferences**: Customize app experience through:
  - **Language Selection**: Choose preferred language for the interface
  - **Theme Options**: Switch between different visual themes and display modes

### Support and Assistance
- **Support Section**: Direct access to help and assistance:
  - **Personal Support**: Connect directly with support staff or developers for personalized assistance
  - **Help Center**: Access comprehensive support resources and documentation
  - **Direct Communication**: Establish direct contact with the support team for issue resolution

### Account Management
- **Logout Option**: Secure logout functionality to safely exit your account session

## Vehicle Management

When you click the add button on the renter main screen, you navigate to the vehicle creation interface. This comprehensive process allows renters to list their vehicles on the platform with detailed information and specifications.

<p align="center">
  <img src="https://github.com/user-attachments/assets/49652d41-f0f6-4e0f-813e-097c7f3251f1" height="400"/>
  &nbsp;&nbsp;&nbsp;
 <img src="https://github.com/user-attachments/assets/7979fa12-7640-493c-bd5f-13bd567e4db9" height="400"/>
  &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/71d9e199-05bb-41ba-9fc8-9ddacc64d7e2" height="400"/>
   &nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/32765f75-7e57-4966-ba59-50cb7e01186c" height="400"/>
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
  <img src="https://github.com/user-attachments/assets/7ad23a16-918b-4c0e-9ffc-9514d258c5bc" height="400"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/37975b4d-2d5b-4e33-bf97-693fbd01ff1f" height="400"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/71d9e199-05bb-41ba-9fc8-9ddacc64d7e2" height="400"/>
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
  <img src="https://github.com/user-attachments/assets/2a53c418-2103-40d1-82bb-f35225931221" height="400" alt="Vehicle Details Section 1"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/2da8fc20-fee8-4acd-938b-afcca3ef819a" height="400" alt="Vehicle Details Section 2" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/45dbbc87-9f02-4bcd-ad50-7c922d62fb92" height="400" alt="Vehicle Details Section 3"/>
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
