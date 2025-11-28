package com.struts.validators
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class SameValidator extends Validator
	{
		private var results:Array;
		public function SameValidator()
		{
			super();
		}
		
		private var _toSource : Object;
		public function  set toSource(value : Object):void 
		{
			this._toSource = value;
		}
		private var _toProperty : String;
		public function  set toProperty(value : String):void 
		{
			this._toProperty = value;
		}
		
		private var _errorMessage : String;
		public function set errorMessage(value : String):void
		{
			this._errorMessage = value;
		} 


		override protected function doValidation(value:Object):Array{
			results = [];
			results = super.doValidation(value);
			if(value!=null)
			{
				if(_toSource && _toProperty)
				{
					var _value : Object = _toSource[_toProperty];
					if(value != _value)
					{
						results.push(new ValidationResult(true, null, "notSame", this._errorMessage));
					}
				}
			}
			return results;
		}		
	}
}