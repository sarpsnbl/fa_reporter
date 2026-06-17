# KanSay

A mobile application project for inventory counting and toll reports for Kanat Boya ArGe (R&D). A student group project for Üsimp (Üniversite Sanayi İşbirliği). KanSay is a Flutter-based mobile application designed to efficiently scan fixed asset IDs using Google ML Kit OCR and generate Excel reports summarizing asset statuses.

The application is deployed at the Kanat Boya factory to streamline, automate, and verify the physical inventory counts of fixed assets. By combining mobile optical character recognition (OCR) and local database processing, KanSay eliminates manual data entry errors and automates report generation.

It is designed to assist inventory personnel during routine asset audits, enabling them to scan physical asset tag barcodes or text labels, instantly verify asset locations against target locations in the company's IFS ERP system, and document asset status on the spot.

## Key Features

- Real-Time OCR scanning: Uses Google ML Kit Text Recognition to scan and capture fixed asset IDs directly through the device's camera.
- Asset verification and database matching: Cross-references scanned asset IDs in real-time with the local database registry preloaded as assets/data.xlsx.
- Location verification: Automatically compares the selected counting location against the asset's IFS target location ("IFS Olması Gereken Lokasyon") and marks it as TRUE or FALSE.
- Condition reporting: Allows users to quickly select the current status of each asset (SAĞLAM/Intact, HURDA/Scrap, ARIZALI/Defective, KAYIP/Lost) via a drop-down menu.
- Offline-first functionality: Operates entirely offline without needing an active internet connection, storing audit data locally until the counting session is completed.
- Excel report generation: Automatically creates formatted Excel files (sayim[CountNo]_[Date].xlsx) detailing the audited items.
- Native file sharing: Utilizes native share features to export and share the generated Excel reports.

## Technology Stack and Dependencies

- Core Framework: Flutter
- Programming Language: Dart
- Text Recognition: google_mlkit_text_recognition
- Camera Integration: camera, image_picker
- Excel Processing: excel
- File Sharing: share_plus
- Path Management: path_provider, path

## Directory and File Structure

The project codebase is organized as follows inside the lib directory:

- lib/main.dart: Entry point of the application. Handles global initialization, asset preloading, and defines the application-wide theme and color scheme.
- lib/data/:
  - mock_reports.dart: Mock structures for auditing reports.
- lib/excel/:
  - excel_processor.dart: Handles Excel reading, ID retrieval, location matching logic, and writes output Excel sheets.
  - excel_share.dart: Provides the ExcelShareButton widget using share_plus.
  - regex_finder.dart: Internal tool to analyze unique ID formats in the registry file.
- lib/utils/:
  - app_directory_getset.dart: Tracks application document directories.
  - excel_getset.dart: Manages in-memory state of the loaded Excel rows.
  - file_load_save.dart: Utilities for reading preloaded assets and writing the final report files.
  - previous_id.dart: Tracks previously scanned ID states.
  - user_getset.dart: Stores user session parameters (operator name, count number, target location, date).
- lib/widgets/:
  - recognized_id_dialog.dart: Shows the scanned ID in an editable dialog box so that users can fix potential OCR reading errors before proceeding.
  - entry_screen/:
    - first_screen.dart: Initial configuration screen where the operator enters their name, count number, and selects their current department/location.
  - ocr/:
    - camera_view.dart: Controls camera feed and inputs.
    - detector_view.dart: Wraps camera and gallery view options.
    - gallery_view.dart: Allows uploading an image from the device's gallery to perform OCR.
    - text_detector_view.dart: Manages OCR processing and triggers the results dialog.
    - text_detector_painter.dart: Draws visual boundaries around detected text strings in the camera feed.
  - data_entry/:
    - data_entry_view.dart: Shows details of the matched asset, contains the status dropdown, and handles item saving.
    - previous_entries_view.dart: Screen displaying list of items scanned during the current session, allowing the user to edit their status.
    - previous_data_view.dart: Screen for reviewing historical counts.
    - entry_confirmation_popup.dart: Dialog presenting next actions (continue scanning, review entries, or complete count).
    - end_inventory_counting_view.dart: Wrap-up view displaying session statistics and offering options to share the final report or return to the main screen.

## Getting Started

To run the application locally or deploy it to a test device:

1. Clone the repository to your local development machine.
2. Install the Flutter SDK (compatible with version 3.5.4 or higher).
3. Verify that your target device (Android/iOS) is connected or launch an emulator.
4. Run the following command in the project root directory to fetch all required packages:
   flutter pub get
5. Run the application using:
   flutter run

## Developers

- Alkım Gönenç Efe
- Sarp Sünbül
- Damla Parlakyıldız