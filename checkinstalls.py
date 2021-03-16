import importlib
spam_spec = importlib.util.find_spec("spam")
found = spam_spec is not None
