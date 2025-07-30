# Aggar App 
Aggar is a vehicle rental platform connecting vehicle owners with customers. Owners can list, edit, and delete their vehicles while managing bookings. Customers search for vehicles by rating, type, brand, or distance, then book securely. The app includes mapping services, notifications, payment processing, and an admin dashboard for platform management, reporting, and user moderation.

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
    - [Vehicle Creation Page](#vehicle-creation-page)
    - [Vehicle Modification Page](#vehicle-modification-page)
    - [Vehicle Discount Page](#vehicle-discount-page)
    - [Vehicle Type & Brand Management Page](#vehicle-type--brand-management-page)
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
*Comprehensive vehicle listing and management system*

### Vehicle Creation Page
*Interface for adding new vehicles to the platform*

### Vehicle Modification Page
*Tools for editing existing vehicle listings*

### Vehicle Discount Page
*Pricing and discount management for vehicle listings*

### Vehicle Type & Brand Management Page
*Administrative interface for managing vehicle categories, types, and brands*

## Vehicle Details and Booking
*Detailed vehicle information and reservation system*

### Renter Vehicle Details Page
*Vehicle owner's view of their listed vehicles with management options*

### Customer Vehicle Details Page
*Customer view with booking functionality and detailed vehicle information*