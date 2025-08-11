--インフェルニティ・ビショップ
function c600.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c600.spcon)
	e1:SetOperation(c600.activate)
	c:RegisterEffect(e1)

	-- local e5=Effect.CreateEffect(c)
	-- e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	-- e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e5:SetCode(EVENT_SUMMON_SUCCESS)
	-- e5:SetOperation(c600.atkop)
	-- c:RegisterEffect(e5)
	-- local e10=e5:Clone()
	-- e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	-- c:RegisterEffect(e10)
	-- local e98=e5:Clone()
	-- e98:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	-- c:RegisterEffect(e98)
end

function c600.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_GRAVE,0)==0
end

function c600.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(e:GetHandler():GetControler(),3,REASON_EFFECT)
end

function c600.atkop(e,tp,eg,ep,ev,re,r,rp)
            e:GetHandler():RegisterFlagEffect(592,RESET_EVENT+0x1fe0000,0,1)
end
