--ダークネス １
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)	
end
s.listed_series={0x316}
s.listed_names={511310104,511310105}

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return true end
	if Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(id)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	end	
end
function s.darkness(c)
	return c:IsFaceup() and c:GetFlagEffect(id)~=0 and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsSetCard(0x316)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
	end
	local g=Duel.GetMatchingGroup(s.darkness,tp,LOCATION_SZONE,0,e:GetHandler())
	if g:GetCount()>0 then
		while g:GetCount()>0 do
		   local tc=g:GetFirst()
		   s.zero(e:GetHandler(),tp)
		   g:RemoveCard(tc)
	    end
	end		
end

function s.zero(tc,tep)
	local te=tc:GetActivateEffect()
	if te==nil or tc:CheckActivateEffect(true,false,false)==nil then return end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	Duel.ClearTargetCard()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
	tc:CreateEffectRelation(te)
	local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if gg then  
		local etc=gg:GetFirst()	
		while etc do
			etc:CreateEffectRelation(te)
			etc=gg:GetNext()
		end
	end						
	if operation then 
		local tc2=Duel.GetFirstTarget()
		if tc2:IsRelateToEffect(te) and tc2:IsFaceup() and not tc2:IsImmuneToEffect(te) then
			local e1=Effect.CreateEffect(tc)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(1000)
			tc2:RegisterEffect(e1)
		end
	end
	tc:ReleaseEffectRelation(te)					
	if gg then  
		local etc=gg:GetFirst()												 
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=gg:GetNext()
		end
	end 
end