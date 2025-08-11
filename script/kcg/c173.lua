--グランエルＴ3 
local s, id = GetID()
function s.initial_effect(c)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon2)
	c:RegisterEffect(e1)

	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31930787,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
end
s.listed_series={0x3013}

function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3013)
end
function s.sdcon2(e)
	return not Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function s.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,0,LOCATION_MZONE,1,nil) 
			and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqlimit(e,c)
	  local tc2=e:GetLabelObject()
	  return c==tc2
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil) 
	if #g<1 then return end
	local tc2=g:GetFirst()
	if tc2:IsFaceup() and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		-- local atk=tc:GetTextAttack()
		-- if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,tc2,false) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(tc2)
		tc:RegisterEffect(e1)
			
			--if atk>0 and tc2:IsSetCard(0x3013) then
				--local e2=Effect.CreateEffect(c)
				--e2:SetType(EFFECT_TYPE_EQUIP)
				--e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				--e2:SetCode(EFFECT_UPDATE_ATTACK)
				--e2:SetReset(RESET_EVENT+0x1fe0000)
				--e2:SetValue(atk)
				--tc:RegisterEffect(e2)
			--end
		-- else Duel.SendtoGrave(tc,REASON_EFFECT) 
	end
end
