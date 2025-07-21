> Stuff in {{}} indicate that you can name that part whatever you want.

### Form with validation

#### Used Stuff List:

1. Used Widgets list:

- build (root of this one widget, would not note in after notes)
- Form
- TextFormField / TextField
- ElevatedButton / FloatingActionButton(opt)
- (ScaffoldMessenger &) SnackBar
- Column (opt, also used every often, would not note in after notes)
- SizedBox (opt, UI purpose, also used every often, would not note in after notes)
- Text (literly everywhere, would not not in after notes)

2. Other used stuff list:

- State<{{T}}> createState() => \_{{T}}State();
- GlobalKey<FormState>();
- <{{K}}>.currentState!.validate()
- ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: ...));
- TextEditingController
- showDialog(context: context, builder: (context) {return...})
- dispose()
- Builder(builder: (BuildContext context) {return })

#### Form structure sample

> All suffix // part are not required but good to have

1. Using stateful widget:

```
class {{FormName}} extends StatefulWidget {
  const {{FormName}}({super.key});

  @override
  State<{{FormName}}> createState() => \_{{FormName}}State();
}
```

2. declare Form widget context:

```
class _{{FormName}}State extends State<EmologForm> {
  // global key to identify Form widget & validation
  // prefer way to name
  final _{{formkey}} = GlobalKey<FormState>();

  // text controller
  // prefer way to name
  final TextEditingController _{{textController}} = TextEditingController();

  // used to discard resources used by obj when don't need obj anymore, avoid mmr leak
  @override
  void dispose() {
    _{{textController}}.dispose();
    super.dispose();
  }

  // some funct to react w/ addListener
  void _printLastestValue() {
    final text = _{{textController}}.text;
    print('$text (${text.characters.length})');
  }

  // listener of TextEditingController
  @override
  void initState() {
    super.initState();
    _{{textController}}.addListener(_printLastestValue);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _{{formkey}},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // UI look
        children: <Widget>[
          const Text(...),
          SizedBox(height: 10), // UI look
          SizedBox(
            width: 500, // UI look
            child: TextFormField(
              maxLines: 5, // UI look
              decoration: const InputDecoration(
                hintText: '...',
              ), // UX encourage user to input
              // validator receives text that user entered
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: _{{textController}},
            ),
          ),
          SizedBox(height: 15), // UI look
          ElevatedButton(
            onPressed: () {
              if (_{{formkey}}.currentState!.validate()) {
                final {text} = _{{textController}}.text;
                // form is valid
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${{text}} has been recorded')),
                );
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return AlertDialog(content: Text({{text}}));
                //   },
                // );
                _{{textController}}.clear();
              }
            },
            child: const Text('Submit', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
```

#### Validation

To check if form is valid by call validate function, used `.validate()` that call all **validator**(s) inside that form, idealy when submit button is pressed.

1. Of TextFormField:
   TextFormField has **validator** field/method with struct: `validator: () => ` hoặc `validator: () { if (value is condition) return A; return B;}` to check if input is legit to take.

> **validator** use case:

`TextFormField(validator: (value) {if (good) return ...; return null;})`

> brief struct with **GlobalKey**:

```
final _{{formkey}} = GlobalKey<FormState>();
Widget build(BuildContext context) {
  return Form(
    key: _{{formkey}},
    child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {if (good) return ...; return null;},
          ),
            ...
          ElevatedButton(
            onPressed: () {if (_{{formkey}}.currentState!.validate()) ...}, // call to validator()
            child: ... // visual button to submit changes
          ),]));}
```

2. Of Form:
   Form has `key` field take the key that created by sth like **GlobalKey<T>()** to let the key access widget from outside widget tree, in this case T is `FormState` type. The key gonna have access to state and use syntax `[keyname].currentState!.validate()` to call `validator`. Careful to use _GlobalKey_ to avoid bypass all widget tree, though that easier to read.
   When `TextFormField`, other field and `Button` aren't _inside_ `Form` needed validation, choose **Builder** to wrap submit button up and `context` to use `Form.of(context).validate()`, checking all `validator` in that `Form`.
   When `TextFormField`, other field and `Button` are _inside_ `Form` needed validation, call `Form.of(context).validate()` directly without any other stuff.

> brief struct of basic case use case:

```
Widget build(BuildContext context) {
  return Form(
    child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {if (good) return ...; return null;},
          ),
            ...
          ElevatedButton(
            onPressed: () { if(Form.of(Context)?.validate()) ...}  // call to validator()
            child: ... // visual button to submit changes
          )
        ]));}
```

> brief struct of **Builder** use case:

```
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Form(
        child: TextFormField(validator: ...),
      ),
      Builder(
        builder: (BuildContext context){
            return ElevatedButton(
                onPressed: () {if (Form.of(context)?.validate()) ...},
                child: Text('Submit'),
            );
        }
      )
    ],
  );
}
```

#### Inform change handle (UX)

In this sample, **ScaffoldMessenger** is used to show **SnackBar** that inform the process is working, when button is clicked. Have to call `ScaffoldMessenger.of(context).showSnackBar()` to show `SnackBar` but don't need to wrap / write directly that inside a **Scaffold** (tree still need `Scaffold` at root though).

> **SnackBar** use case:

`ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')),)`

### Handling changes (UX)

There are two way to handle changes: when there is change in form; when user chosen to save changes (that also usually mean click the submit button).

> Disclamer: handle change != get/save data. This indicates how your app react with change and when.

1. Whenever changes appear in form:
   `TextFormField` or `TextField` have **onChanged()** callback. Whenever the text changes (like every single character), that gonna be run so super careful with that.

> **onChanged()** use case:

`TextField(onChanged:(text){...})`
`TextFormField(onChanged:(text){...})`

2. When submit / save changes:
   Using **TextEditingController** to check if there're changes and connect with **controller** property of `TextFormField` or `TextField` to handle changes of those field. Remember to `dispose()` both that controller and `super` when that widget is removed from tree to avoid mmr leak (only need to override `dispose` funct 'cause widget auto call `dispose` when that widget about to get rid of the tree).
   **controller** only save temp value, if you want to react when user click the submit button, call `_{{textController}}.text` in `onPressed` and do some logic with that.

> **TextEditingController** use case:

`final TextEditingController _{{textController}} = TextEditingController();`

`TextFromField(controler: _{{textController}},...)`

```
ElevatedButton(onPressed: (){
  final {{text}} = _{{textController}}.text;
    ...
  _{{textController}}.clear(); // optional
  },
    ...
)
```

> dispose func when use **TextEditingController**:

```
@override
void dispose() {
  _{{textController}}.dispose();
  super.dispose();
}
```

> Optional funcs to use with **TextEditingController**:

```
// some funct to react w/ addListener
void _{{printLastestValue}}() {
  final {{text}} = _{{textController}}.text;
  print('${{text}} (${{{text}}.characters.length})');
}

// listener of TextEditingController
@override
void initState() {
  super.initState();
  _{{textController}}.addListener(_{{printLastestValue}});
}
```

### Retrieve Value

This gonna get data when user _entered_ into a text field.
Common use is **showDialog** and **Snackbar**. **showDialog** gonna pop a modal on whole screen, while **Snackbar** just slide into and not interrupt any action. Put one of them in `onPressed` of the button to get call when user clicked the button. There're also other common button to used with is `FloatingActionButton`.

> **showDialog** use case:

```
ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: Text(_{{textController}}.text));
      },
    );
    _{{textController}}.clear();
  },
  child: const Text('Submit'),
),
```

> **Snackbar** use case:

```
ElevatedButton(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_{{textController}}.text} has been recorded')),
    );
    _{{textController}}.clear();
  },
  child: const Text('Submit'),
),
```

> `FloatingActionButton`:

only different w/ ElevatedButton is `tooltip` property used to show some description when hover the button.

`FloatingActionButton(tooltip: 'Show me the value!',...)`
