import 'package:flutter/material.dart';

class GridViewScreen extends StatelessWidget {
  final int itemCount = 12;

  Widget gridItem(int i, {double borderRadius = 12}) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.primaries[i % Colors.primaries.length].shade200,
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: 36,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text('Item ${i + 1}')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView Exercise')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text('Fixed Column Grid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 320,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(), // để list scroll chứ grid ko
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
                children: List.generate(itemCount, (i) => gridItem(i)),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Responsive Grid', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GridView.extent(
              maxCrossAxisExtent: 150,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
              children: List.generate(itemCount, (i) => gridItem(i, borderRadius: 8)),
            ),
          ],
        ),
      ),
    );
  }
}
