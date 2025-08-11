local s,id=GetID()
function s.initial_effect(c)
	--Extra Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetOperation(s.extracon)
	e1:SetValue(s.extraval)
	c:RegisterEffect(e1)
	if s.flagmap==nil then
		s.flagmap={}
	end
	if s.flagmap[c]==nil then
		s.flagmap[c] = {}
	end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(s.atkcon)
	e2:SetCost(s.atkcost1)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop1)
	c:RegisterEffect(e2)
end

function s.extracon(c,e,tp,sg,mg,lc,og,chk)
	return e:GetHandler():IsAbleToRemove() and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)-- and sg:FilterCount(s.flagcheck,nil)<2
end
function s.flagcheck(c)
	return c:GetFlagEffect(id)>0
end
function s.extraval(chk,summon_type,e,...)
	local c=e:GetHandler()
	if chk==0 then
		local tp,sc=...
		--if summon_type~=SUMMON_TYPE_LINK or not sc:IsRace(RACE_CYBERSE) or Duel.GetFlagEffect(tp,id)>0 then
		if summon_type~=SUMMON_TYPE_LINK or not sc:IsRace(RACE_CYBERSE)then
			return Group.CreateGroup()
		else
			table.insert(s.flagmap[c],c:RegisterFlagEffect(id,0,0,1))
			return Group.FromCards(c)
		end
	elseif chk==1 then
		local sg,sc,tp=...
		if summon_type&SUMMON_TYPE_LINK == SUMMON_TYPE_LINK and #sg>0 then
			Duel.Hint(HINT_CARD,tp,id)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	elseif chk==2 then
		for _,eff in ipairs(s.flagmap[c]) do
			eff:Reset()
		end
		s.flagmap[c]={}
	end
end
function Link.Operation(f,minc,maxc,specialchk)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,must,g,min,max)
				local g,filt,emt=table.unpack(e:GetLabelObject())
				for _,ex in ipairs(filt) do
					if ex[3]:GetValue() then
						ex[3]:GetValue()(1,SUMMON_TYPE_LINK,ex[3],ex[1]&g,c,tp)
						if ex[3]:CheckCountLimit(tp) then
							ex[3]:UseCountLimit(tp,1)
						end
					end
				end
				for tc in g:Iter() do
					local formud_eff=tc:IsHasEffect(50366775)
					if formud_eff then
						local res1=tc:IsCanBeLinkMaterial(c,tp) and (not f or f(tc,c,SUMMON_TYPE_LINK|MATERIAL_LINK,tp))
						local label={formud_eff:GetLabel()}
						for i=1,#label-1,2 do
							tc:AssumeProperty(label[i],label[i+1])
						end
						local res2=tc:IsCanBeLinkMaterial(c,tp) and (not f or f(tc,c,SUMMON_TYPE_LINK|MATERIAL_LINK,tp))
						if not res2 or (res1 and res2 and not Duel.SelectEffectYesNo(tp,tc)) then
							Duel.AssumeReset()
						end
					end
				end
				c:SetMaterial(g)
				local ogre=g:Filter(s.filter,nil)
				if #ogre~=0 then
					g:Sub(ogre)
					Duel.Remove(ogre,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
					local e3=Effect.CreateEffect(ogre:GetFirst())
					e3:SetDescription(3000)
					e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetRange(LOCATION_MZONE)
					e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
					e3:SetValue(1)
					c:RegisterEffect(e3,true)
					ogre:DeleteGroup()
				end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
				aux.DeleteExtraMaterialGroups(emt)
			end
end
function s.filter(c)
	return c:IsOriginalCodeRule(id) and c:IsLocation(LOCATION_GRAVE) and c:GetFlagEffect(id)>0
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function s.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST|REASON_DISCARD)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATKDEF)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.atkop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		tc:RegisterEffect(e1)
	end
end