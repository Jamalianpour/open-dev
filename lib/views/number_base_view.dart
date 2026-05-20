import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_dev/utils/number_base_utils.dart';

class NumberBaseView extends StatefulWidget {
  const NumberBaseView({super.key});

  @override
  State<NumberBaseView> createState() => _NumberBaseViewState();
}

class _NumberBaseViewState extends State<NumberBaseView> {
  final Map<NumberBase, TextEditingController> _controllers = {
    for (final b in NumberBase.values) b: TextEditingController(),
  };
  final TextEditingController _opB = TextEditingController(text: '0');
  final TextEditingController _shiftBy = TextEditingController(text: '1');

  BigInt _value = BigInt.zero;
  BitWidth _width = BitWidth.bits32;
  NumberBase? _editing;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _syncFields();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _opB.dispose();
    _shiftBy.dispose();
    super.dispose();
  }

  void _syncFields() {
    for (final base in NumberBase.values) {
      if (base == _editing) continue;
      _controllers[base]!.text = NumberBaseUtils.format(_value, base, _width);
    }
  }

  void _onChanged(NumberBase base, String text) {
    if (text.isEmpty) {
      setState(() {
        _value = BigInt.zero;
        _error = '';
        _editing = base;
        _syncFields();
        _editing = null;
      });
      return;
    }
    try {
      final v = NumberBaseUtils.parse(text, base);
      setState(() {
        _value = v & _width.mask;
        _error = '';
        _editing = base;
        _syncFields();
        _editing = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _setValue(BigInt v) {
    setState(() {
      _value = v & _width.mask;
      _error = '';
      _syncFields();
    });
  }

  BigInt _parseOpB() {
    final t = _opB.text.trim();
    if (t.isEmpty) return BigInt.zero;
    try {
      return NumberBaseUtils.parse(t, NumberBase.decimal) & _width.mask;
    } catch (_) {
      return BigInt.zero;
    }
  }

  int _parseShift() {
    final t = _shiftBy.text.trim();
    final n = int.tryParse(t) ?? 0;
    return n.clamp(0, _width.bits);
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Number Base Converter',
              style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          const Text('Width: '),
          const SizedBox(width: 8),
          SegmentedButton<BitWidth>(
            segments: const [
              ButtonSegment(value: BitWidth.bits8, label: Text('8')),
              ButtonSegment(value: BitWidth.bits16, label: Text('16')),
              ButtonSegment(value: BitWidth.bits32, label: Text('32')),
              ButtonSegment(value: BitWidth.bits64, label: Text('64')),
            ],
            selected: {_width},
            onSelectionChanged: (s) {
              setState(() {
                _width = s.first;
                _value = _value & _width.mask;
                _syncFields();
              });
            },
            showSelectedIcon: false,
          ),
        ],
      ),
    );
  }

  Widget _baseField(NumberBase base) {
    final inputFormatters = <TextInputFormatter>[];
    switch (base) {
      case NumberBase.binary:
        inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(r'[01]')));
        break;
      case NumberBase.octal:
        inputFormatters
            .add(FilteringTextInputFormatter.allow(RegExp(r'[0-7]')));
        break;
      case NumberBase.decimal:
        inputFormatters
            .add(FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')));
        break;
      case NumberBase.hexadecimal:
        inputFormatters
            .add(FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')));
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(base.label,
                style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: TextField(
              controller: _controllers[base],
              inputFormatters: inputFormatters,
              style: const TextStyle(fontFamily: 'monospace'),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), gapPadding: 0),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  tooltip: 'Copy',
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: _controllers[base]!.text));
                  },
                ),
              ),
              onChanged: (v) => _onChanged(base, v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBitGrid(BuildContext context) {
    final bits = NumberBaseUtils.toBits(_value, _width);
    final cells = <Widget>[];
    for (int i = 0; i < _width.bits; i++) {
      final bitIndex = _width.bits - 1 - i;
      final isOn = bits[i] == '1';
      final isByteBoundary = bitIndex % 8 == 0 && bitIndex != 0;
      cells.add(_BitCell(
        index: bitIndex,
        on: isOn,
        onTap: () => _setValue(
            NumberBaseUtils.toggleBit(_value, bitIndex, _width)),
      ));
      if (isByteBoundary) {
        cells.add(const SizedBox(width: 8));
      }
    }
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 0,
      runSpacing: 8,
      children: cells,
    );
  }

  Widget _buildOpsPanel(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget opBtn(String label, VoidCallback onTap) {
      return Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: OutlinedButton(onPressed: onTap, child: Text(label)),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bitwise operations',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 60, child: Text('Operand B (dec):')),
              Expanded(
                child: TextField(
                  controller: _opB,
                  style: const TextStyle(fontFamily: 'monospace'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8), gapPadding: 0),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(children: [
            opBtn('A AND B',
                () => _setValue(NumberBaseUtils.and(_value, _parseOpB(), _width))),
            opBtn('A OR B',
                () => _setValue(NumberBaseUtils.or(_value, _parseOpB(), _width))),
            opBtn('A XOR B',
                () => _setValue(NumberBaseUtils.xor(_value, _parseOpB(), _width))),
            opBtn('NOT A',
                () => _setValue(NumberBaseUtils.not(_value, _width))),
          ]),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Shift by '),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _shiftBy,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8), gapPadding: 0),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _setValue(
                    NumberBaseUtils.shiftLeft(_value, _parseShift(), _width)),
                child: const Text('A << n'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _setValue(
                    NumberBaseUtils.shiftRight(_value, _parseShift(), _width)),
                child: const Text('A >> n'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signed = NumberBaseUtils.asSigned(_value, _width);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const Divider(indent: 8, endIndent: 8),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final base in NumberBase.values) _baseField(base),
                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(_error,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Signed (${_width.bits}-bit): ',
                        style: Theme.of(context).textTheme.titleSmall),
                    SelectableText(signed.toString(),
                        style: const TextStyle(fontFamily: 'monospace')),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Bits',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _buildBitGrid(context),
                const SizedBox(height: 24),
                _buildOpsPanel(context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BitCell extends StatelessWidget {
  const _BitCell({required this.index, required this.on, required this.onTap});

  final int index;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 42,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: on ? cs.primaryContainer : cs.surfaceVariant,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: on ? cs.primary : cs.outlineVariant, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              on ? '1' : '0',
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: on ? cs.onPrimaryContainer : cs.onSurfaceVariant,
              ),
            ),
            Text(
              '$index',
              style: TextStyle(
                fontSize: 9,
                color: cs.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
