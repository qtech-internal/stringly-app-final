import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart'; // Import the image_cropper package
import 'package:photo_manager/photo_manager.dart';

class CustomImagePickerOneAtATime extends StatefulWidget {
  const CustomImagePickerOneAtATime({super.key});

  @override
  _CustomImagePickerOneAtATimeState createState() => _CustomImagePickerOneAtATimeState();
}

class _CustomImagePickerOneAtATimeState extends State<CustomImagePickerOneAtATime> {
  List<AssetEntity> recentImages = [];
  List<AssetPathEntity> albums = [];
  AssetEntity? selectedImage;
  String selectedAlbum = "Recents";
  String? croppedImagePath;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (permission.isAuth) {
      final List<AssetPathEntity> fetchedAlbums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      setState(() {
        albums = fetchedAlbums;
        selectedAlbum = albums.first.name;
      });

      await _fetchImagesFromAlbum(albums.first);
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<void> _fetchImagesFromAlbum(AssetPathEntity album) async {
    final List<AssetEntity> images = await album.getAssetListPaged(page: 0, size: 50);

    setState(() {
      recentImages = images;
      print('Loaded ${images.length} images from album: ${album.name}');
    });
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      await _cropImage(photo.path); // Crop the image after picking
    }
  }

  Future<void> _cropImage(String imagePath) async {
    File? croppedFile = (await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    )) as File?;

    if (croppedFile != null) {
      setState(() {
        croppedImagePath = croppedFile.path; // Store the cropped image path
        selectedImage = null; // Reset selectedImage to null
      });
      Navigator.pop(context, [croppedFile.path]);
    }
  }

  void _selectImage(AssetEntity image) async {
    final File? file = await image.file;
    if (file != null) {
      final int fileSize = await file.length(); // File size in bytes
      final double fileSizeMB = fileSize / (1024 * 1024); // Convert to MB

      if (fileSizeMB > 5) {
        // Show Snackbar if the image size exceeds 5MB
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'The selected image is too large (${fileSizeMB.toStringAsFixed(2)} MB). Please choose an image smaller than 5MB.',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return; // Prevent selecting the image
      }
    }

    // Set the selected image before cropping
    setState(() {
      selectedImage = image; // Set the selected image
    });

    await _cropImage(file!.path); // Crop the image after selecting
  }

  void _openAlbumSelectionDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: albums.map((album) {
            return ListTile(
              title: Text(album.name),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  selectedAlbum = album.name;
                });
                _fetchImagesFromAlbum(album);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Large preview for the selected image or the last image in the gallery
          croppedImagePath != null
              ? Image.file(
            File(croppedImagePath!),
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          ):
          selectedImage != null
              ? FutureBuilder<File?>(
            future: selectedImage!.file,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                return Image.file(
                  snapshot.data!,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              }
              return const SizedBox(
                height: 350,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          )
              : recentImages.isNotEmpty
              ? FutureBuilder<File?>(
            future: recentImages.last.file,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                return Image.file(
                  snapshot.data!,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              }
              return const SizedBox(
                height: 350,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          )
              : const SizedBox(
            height: 350,
            child: Center(
              child: Text('No image selected', style: TextStyle(color: Colors.white)),
            ),
          ),
          // Albums section
          GestureDetector(
            onTap: _openAlbumSelectionDialog,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    selectedAlbum,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
          // Recent images section
          Expanded(
            child: Container(
              color: Colors.black,
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: recentImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: _pickImageFromCamera,
                      child: Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.camera_alt, size: 40, color: Colors.white),
                      ),
                    );
                  }
                  final AssetEntity image = recentImages[index - 1];
                  final bool isSelected = selectedImage?.id == image.id;

                  return GestureDetector(
                    onTap: () {
                      print('Image tapped: ${image.id}');
                      _selectImage(image);
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FutureBuilder<Uint8List?>(
                          future: image.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.white),
                            );
                          },
                        ),
                        if (isSelected)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Upload button
          Container(
            width: 350,
            padding: const EdgeInsets.only(top: 8.0, bottom: 25),
            child: ElevatedButton(
              onPressed: () async {
                if (selectedImage != null) {
                  final File? file = await selectedImage!.file;
                  if (file != null) {
                    print('Selected file path: ${file.path}');
                    Navigator.pop(context, [file.path]);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select an image.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Upload'),
            ),
          ),
        ],
      ),
    );
  }
}