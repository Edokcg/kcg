--千年首饰
function c900000096.initial_effect(c)
	
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--翻开双方卡组最上面5张卡
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c900000096.activate)
	c:RegisterEffect(e2)
	
	--效果不会被无效化
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e3)
end
-------------------------------------------------------------------------------------------------------------------------------------------
function c900000096.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(1-tp,5)
	Duel.ConfirmDecktop(tp,5)
end
