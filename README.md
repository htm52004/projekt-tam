# Kraje Świata - Projekt Zaliczeniowy

Aplikacja mobilna stworzona w frameworku **Flutter** w ramach przedmiotu **Technologie Aplikacji Mobilnych**

Projekt implementuje architekturę czystą z podziałem na warstwy danych (data) oraz prezentacji (presentation) i integruje zewnętrzne usługi REST API oraz platformę Firebase.

---

## Funkcjonalności i Spełnione Wymagania

### Wymagania Podstawowe (4.0)
* **Wieloekranowość:** Aplikacja posiada dedykowany ekran listy elementów (`CountriesListScreen`) oraz zaawansowany widok szczegółów wybranego kraju (`CountryDetailsScreen`).
* **Obsługa wielu zapytań REST:** Zaimplementowano obsługę dwóch osobnych i niezależnych punktów końcowych (endpoints) REST API v5 serwisu RestCountries:
    1. Pobranie pełnej listy krajów (`/countries/v5?limit=100`).
    2. Dynamiczne wyszukiwanie krajów po nazwie przekazywanej w parametrze (`/countries/v5/name?q={query}`).
* **Tryb Offline (Lokalna baza danych):** Pełna dostępność danych bez połączenia z siecią dzięki wykorzystaniu bazy **Hive**. Pomyślnie pobrane dane sieciowe są automatycznie buforowane (cache), a w przypadku braku internetu aplikacja płynnie ładuje ostatni zapamiętany stan.
* **Stan ładowania:** Interfejs użytkownika w pełni obsługuje asynchroniczność poprzez widżety `FutureBuilder` oraz estetyczne animacje wskaźników ładowania (`CircularProgressIndicator`).
* **Obsługa błędów:** Aplikacja przechwytuje wyjątki sieciowe i parsujące, prezentując użytkownikowi czytelny, dedykowany komunikat o błędzie (np. ekran braku połączenia) wraz z interaktywnym przyciskiem "Spróbuj ponownie".

### Wymagania Dodatkowe na Ocenę Celującą (5.0)
* **Cztery funkcjonalne ekrany:** Struktura aplikacji została rozbudowana do 4 unikalnych widoków zarządzanych przez centralny pasek nawigacyjny (`BottomNavigationBar`):
    1.  **Ekran Główny:** Lista krajów z paskiem wyszukiwania.
    2.  **Ekran Szczegółów:** Zaawansowane informacje o państwie wraz z obsługą flag i dynamicznym dopisywaniem do ulubionych.
    3.  **Ekran Ulubionych:** Widok prezentujący wyłącznie elementy oznaczone przez użytkownika, pobierane bezpośrednio z dedykowanego boxu bazy Hive.
    4.  **Ekran Ustawień:** Panel konfiguracyjny pozwalający na personalizację interfejsu.
* **Dodatkowe funkcjonalności:**
    * *Ulubione (Favorites):* Możliwość permanentnego dodawania/usuwania krajów z poziomu widoku szczegółów za pomocą animowanego przycisku akcji.
    * *Ekran Ustawień / Tryb Ciemny:* Globalne zarządzanie motywem aplikacji (Light/Dark Mode) zrealizowane poprzez reaktywny `ValueListenableBuilder` oraz zapisywanie preferencji użytkownika w bazie Hive.
* **Manualne odświeżanie danych (Pull-to-refresh):** Zaimplementowano natywny widżet `RefreshIndicator` na ekranie głównym, umożliwiający użytkownikowi wymuszenie ponownego odpytania serwera API i aktualizację bazy lokalnej.
* **Integracja usług Firebase:** Do projektu pomyślnie podpięto dwie kluczowe usługi ekosystemu Firebase:
    1.  **Firebase Analytics:** Śledzenie zachowań i ruchu użytkownika w aplikacji.
    2.  **Firebase Crashlytics:** Rejestrowanie krytycznych błędów i wyjątków w celu ciągłego monitorowania stabilności.
* **Analityka zdarzeń (Min. 3 Eventy):** Skonfigurowano i zaimplementowano rejestrację trzech unikalnych zdarzeń analitycznych w Firebase Analytics:
    * `manual_refresh_triggered` – wywoływane w momencie ręcznego odświeżenia listy gestem pull-to-refresh.
    * `view_country_details` – rejestrujące wejście w szczegóły konkretnego państwa (wraz z przekazaniem parametru nazwy kraju).
    * `toggle_favorite` – wywoływane przy zmianie statusu ulubionego kraju (rejestruje nazwę oraz aktualny stan flagi ulubionego).

---
