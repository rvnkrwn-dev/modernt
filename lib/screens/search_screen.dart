import 'package:flutter/material.dart';
import 'package:moderent/screens/detail_screen.dart';
import 'package:moderent/services/vehicle_service.dart';
import 'package:moderent/utils/format_to_idr.dart';
import 'package:moderent/widgets/car_card.dart';
import 'package:moderent/widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  final String? keyword;
  const SearchScreen({super.key, this.keyword});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  final VehicleService _vehicleService = VehicleService();
  List<dynamic> _vehicles = [];
  bool _isLoading = true;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.keyword ?? '');
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    final result = await _vehicleService.getVehicles();

    if (result != null && result['success']) {
      setState(() {
        _vehicles = result['vehicles'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['message'] ?? 'Failed to load vehicles'),
          ),
        );
      }
    }
  }

  void _showFilterBottomSheet(BuildContext context) async {
    List<String> categories = ['All', 'Motorcycle', 'Car'];
    String tempSelectedCategory = selectedCategory;

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder:
              (context, setModalState) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(0xFFBB86FC),
                          child: Text(
                            selectedCategory != 'All' ? "1" : "0",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      children:
                          categories.map((category) {
                            final isSelected = category == tempSelectedCategory;
                            return ChoiceChip(
                              label: Text(
                                category.toUpperCase(),
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : const Color(0xFFBB86FC),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (_) {
                                setModalState(
                                  () => tempSelectedCategory = category,
                                );
                              },
                              selectedColor: const Color(0xFFBB86FC),
                              backgroundColor: const Color(0xFFF3ECFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, tempSelectedCategory);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBB86FC),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Apply Filters",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
        );
      },
    );

    if (result != null && result != selectedCategory) {
      setState(() {
        selectedCategory = result;
      });
    }
  }

  List<dynamic> get filteredVehicles {
    final keyword = _searchController.text.trim().toLowerCase();

    return _vehicles.where((vehicle) {
      final titleMatch = vehicle['title'].toString().toLowerCase().contains(
        keyword,
      );
      final categoryMatch =
          selectedCategory.toLowerCase() == 'All'.toLowerCase() || vehicle['vehicle_type'] == selectedCategory.toLowerCase();
      return titleMatch && categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar:
          (widget.keyword != null && widget.keyword!.isNotEmpty)
              ? AppBar(
                title: const Text("Search"),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
              )
              : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _showFilterBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.05),
                      padding: const EdgeInsets.all(12),
                      minimumSize: const Size(54, 54),
                    ).copyWith(
                      side: const WidgetStatePropertyAll(
                        BorderSide(color: Color(0xFFEDF1F3)),
                      ),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filteredVehicles.isEmpty
                        ? const Center(child: Text("No results found"))
                        : ListView.builder(
                          itemCount: filteredVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = filteredVehicles[index];
                            return Column(
                              children: [
                                CarCard(
                                  title: vehicle['vehicle_name'] ?? '',
                                  price: formatToIdr(vehicle['rental_price'] ?? 0),
                                  imageUrl: vehicle['secure_url_image'] ?? '',
                                  avatarUrl: vehicle['secure_url_image'] ?? '',
                                  onTap: () {
                                    if(mounted) {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(vehicleId: vehicle['id'] ?? 0)));
                                    }
                                  },
                                ),
                                SizedBox(height: 12)
                              ],
                            );
                          },
                        ),
              ),
              SizedBox(height: 24)
            ],
          ),
        ),
      ),
    );
  }
}
