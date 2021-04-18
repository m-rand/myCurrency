# myCurrency

A simple app for managing currencies and their conversion rates. 

- User can select currencies to watch from the list of all available currencies. 
- User can search in countries names.
- User can filter only the selected currencies.
- User can set one currency as a base (-> value is set to 1.0). All other currencies are then recalculated according to actual conversion rates taken from https://v6.exchangerate-api.com/v6/.
- Flags for all countries are loaded from https://github.com/transferwise/currency-flags.

Project extensively uses Combine framework both for networking and for in-app state changes observing. 

**Note:** Currently no errors reporting to user. Will be included in future releases.  