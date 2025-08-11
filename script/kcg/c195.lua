--ダークネス １
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetTarget(s.destg2)
	e3:SetOperation(s.desop2)
	c:RegisterEffect(e3)
end
s.listed_series={0x316}
s.listed_names={511310104,511310105}

function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetFlagEffect(id)~=0 then
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	end
end
function s.darkness(c)
	return c:IsFaceup() and c:GetFlagEffect(id)~=0 and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsSetCard(0x316)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)==0 then return end	
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
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
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
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

