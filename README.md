# myCurrency

A simple app for managing currencies and their conversion rates. 

- User can select currencies to watch from the list of all available currencies. 
- User can set one currency as a base. All other currencies are then recalculated according to actual conversion rates taken from https://v6.exchangerate-api.com/v6/.
- Flags for all countries are loaded from https://github.com/transferwise/currency-flags.

Project extensively uses Combine framework both for networking and for in-app state changes observing. 